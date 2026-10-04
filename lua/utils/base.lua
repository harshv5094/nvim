local M = {}

local config = {
	float_size = 0.8, -- default size of floating terminals (0-1, fraction of the screen)
	split_size = 0.35, -- default height of bottom split terminals (0-1, fraction of the screen height)
}

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "Utils" })
end

local function clamp01(n)
	return math.min(math.max(n, 0), 1)
end

---@param opts? { float_size?: number, split_size?: number }
function M.setup(opts)
	config = vim.tbl_extend("force", config, opts or {})
end

---------------------------------------------------------------------------
-- Terminal
---------------------------------------------------------------------------

---@class UtilsTerminalOpts
---@field type? "float"|"split"  how to display it (default "float")
---@field shared? boolean        true: one terminal reused by both types; false: one per type (default false)
---@field size? number           screen fraction 0-1 (float: width and height, split: height)
---@field id? string             separate terminals by name, e.g. "lazygit" (default "term")
---@field cmd? string|string[]|fun(): string|string[]  command to run (default: your shell)
---@field cwd? string|fun(): string?  working directory; the terminal restarts if it changes
---@field requires? string       executable that must exist, otherwise a warning is shown

---@class UtilsTerminalInstance
---@field buf integer
---@field win integer
---@field job_id integer
---@field cwd? string
---@field kind? "float"|"split"  how it is currently displayed

---@type table<string, UtilsTerminalInstance>
local instances = {}

local function new_instance()
	return { buf = -1, win = -1, job_id = -1, cwd = nil, kind = nil }
end

local function is_visible(inst)
	return inst.win ~= -1 and vim.api.nvim_win_is_valid(inst.win)
end

local function is_alive(inst)
	return inst.job_id ~= -1 and vim.api.nvim_buf_is_valid(inst.buf) and vim.fn.jobwait({ inst.job_id }, 0)[1] == -1
end

local function hide(inst)
	if is_visible(inst) then
		vim.api.nvim_win_hide(inst.win)
	end
	inst.win, inst.kind = -1, nil
end

---Centered float config covering `size` (0-1) of the screen in both directions.
local function float_config(size)
	local usable_h = vim.o.lines - vim.o.cmdheight
	local width = math.max(1, math.min(math.floor(vim.o.columns * size), vim.o.columns - 2)) -- -2: border
	local height = math.max(1, math.min(math.floor(usable_h * size), usable_h - 2))

	return {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width - 2) / 2),
		row = math.floor((usable_h - height - 2) / 2),
		style = "minimal",
		border = "rounded",
	}
end

---Show the instance's buffer in a new window of the given kind.
local function open_win(inst, kind, size)
	if kind == "split" then
		size = clamp01(size or config.split_size)
		local max_h = vim.o.lines - vim.o.cmdheight - 3

		inst.win = vim.api.nvim_open_win(inst.buf, true, {
			split = "below",
			win = -1, -- full-width, like `botright`
			height = math.max(1, math.min(math.floor(vim.o.lines * size), max_h)),
		})

		-- Window-local options belong to the window, so set them on every open
		for name, value in pairs({
			number = false,
			relativenumber = false,
			signcolumn = "no",
			winfixheight = true,
		}) do
			vim.wo[inst.win][name] = value
		end
	else
		inst.win = vim.api.nvim_open_win(inst.buf, true, float_config(clamp01(size or config.float_size)))
	end
	inst.kind = kind
end

---Toggle a terminal. Hiding keeps the process alive; typing `exit` ends it.
---
---  terminal()                                   float, 80% of the screen
---  terminal({ type = "split" })                 bottom split, default height
---  terminal({ type = "float", size = 0.5 })     50% float
---  terminal({ type = "split", shared = true })  split showing the *same* shell as the shared float
---
---With `shared = false` the float and the split are two independent shells.
---With `shared = true` they are one shell, shown in only one place at a time:
---calling the other type moves it there.
---@param opts? UtilsTerminalOpts
function M.terminal(opts)
	opts = opts or {}

	local kind = opts.type or "float"
	if kind ~= "float" and kind ~= "split" then
		return notify(('Invalid terminal type "%s" (use "float" or "split")'):format(tostring(kind)), vim.log.levels.WARN)
	end

	local key = (opts.id or "term") .. ":" .. (opts.shared and "shared" or kind)
	local inst = instances[key]
	if not inst then
		inst = new_instance()
		instances[key] = inst
	end

	if is_visible(inst) then
		if inst.kind == kind then
			if vim.api.nvim_get_current_win() == inst.win then
				hide(inst) -- focused: hide it
			else
				vim.api.nvim_set_current_win(inst.win) -- visible elsewhere: jump to it
				vim.cmd.startinsert()
			end
			return
		end
		hide(inst) -- shared terminal shown as the other type: move it
	end

	if opts.requires and vim.fn.executable(opts.requires) ~= 1 then
		return notify(opts.requires .. " is not installed or not in your PATH.", vim.log.levels.WARN)
	end

	-- Working directory changed since last time: drop the old process
	local cwd = type(opts.cwd) == "function" and opts.cwd() or opts.cwd
	if is_alive(inst) and inst.cwd ~= cwd then
		vim.api.nvim_buf_delete(inst.buf, { force = true })
	end

	local fresh = not is_alive(inst)
	if fresh then
		inst.buf = vim.api.nvim_create_buf(false, true)
	end

	-- Geometry is recalculated on every show, so it follows terminal resizes
	open_win(inst, kind, opts.size)

	if fresh then
		local buf = inst.buf -- captured so a stale callback can't clobber a newer terminal
		local cmd = type(opts.cmd) == "function" and opts.cmd() or opts.cmd or vim.o.shell
		inst.cwd = cwd

		-- Must run while the terminal buffer is current (it is, since the window was entered)
		inst.job_id = vim.fn.jobstart(cmd, {
			term = true,
			cwd = cwd,
			on_exit = function(_, code)
				vim.schedule(function()
					local natural = inst.buf == buf -- false if we replaced/killed it on purpose
					if natural then
						inst.buf, inst.win, inst.job_id, inst.cwd, inst.kind = -1, -1, -1, nil, nil
					end
					if vim.api.nvim_buf_is_valid(buf) then
						vim.api.nvim_buf_delete(buf, { force = true }) -- also closes its window
					end
					if natural and code ~= 0 then
						notify("Terminal exited with code " .. code, vim.log.levels.WARN)
					end
				end)
			end,
		})
	end

	vim.cmd.startinsert()
end

---LazyGit in its own persistent float. Accepts the same options as `terminal`.
---@param opts? UtilsTerminalOpts
function M.lazygit_toggle(opts)
	return M.terminal(vim.tbl_extend("force", {
		id = "lazygit",
		type = "float",
		size = 0.9,
		cmd = { "lazygit" },
		requires = "lazygit",
		cwd = M.project_root,
	}, opts or {}))
end

---------------------------------------------------------------------------
-- Utilities
---------------------------------------------------------------------------

---Add (`"x"`, default) or remove (anything else) the executable bit on the current file.
---@param mode? string
function M.chmod(mode)
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return notify("Buffer has no file", vim.log.levels.WARN)
	end

	local flag = (mode or "x") == "x" and "+x" or "-x"
	local res = vim.system({ "chmod", flag, file }):wait()
	local name = vim.fs.basename(file)

	if res.code == 0 then
		notify(("chmod %s → %s"):format(flag, name))
	else
		notify(("Failed to chmod %s → %s\n%s"):format(flag, name, res.stderr or ""), vim.log.levels.ERROR)
	end
end

---Project root (git root of the buffer, else of the cwd, else the cwd).
---@return string
function M.project_root()
	return vim.fs.root(0, ".git") or vim.fs.root(vim.fn.getcwd(), ".git") or vim.fn.getcwd()
end

return M
