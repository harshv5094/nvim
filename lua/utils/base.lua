local M = {}

local config = {
	height_fraction = 0.35,
}

local state = {
	buf = -1,
	win = -1,
	job_id = -1,
}

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "Utils" })
end

---@param opts? { height_fraction?: number }
function M.setup(opts)
	config = vim.tbl_extend("force", config, opts or {})
end

---Start a shell in the current buffer. `on_exit` runs scheduled, so it's safe to call the API.
---@param on_exit fun(code: integer)
---@return integer job_id
local function spawn_shell(on_exit)
	return vim.fn.jobstart(vim.o.shell, {
		term = true,
		on_exit = function(_, code)
			vim.schedule(function()
				on_exit(code)
			end)
		end,
	})
end

---------------------------------------------------------------------------
-- Bottom split terminal (toggle)
---------------------------------------------------------------------------

local function win_is_open()
	return state.win ~= -1 and vim.api.nvim_win_is_valid(state.win)
end

local function job_is_running()
	return state.job_id ~= -1 and vim.fn.jobwait({ state.job_id }, 0)[1] == -1
end

local function open_split()
	if not vim.api.nvim_buf_is_valid(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true)
	end

	state.win = vim.api.nvim_open_win(state.buf, true, {
		split = "below",
		win = -1, -- full-width, like `botright`
		height = math.max(1, math.floor(vim.o.lines * config.height_fraction)),
	})

	-- Window-local options belong to the window, so set them on every open
	for name, value in pairs({
		number = false,
		relativenumber = false,
		signcolumn = "no",
		winfixheight = true,
	}) do
		vim.wo[state.win][name] = value
	end
end

local function start_shell()
	local buf = state.buf -- captured so a stale callback can't clobber a newer terminal

	state.job_id = spawn_shell(function(code)
		if state.buf == buf then
			state.buf, state.win, state.job_id = -1, -1, -1
		end
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true }) -- also closes its windows
		end
		if code ~= 0 then
			notify("Terminal exited with code " .. code, vim.log.levels.WARN)
		end
	end)
end

function M.toggle_terminal()
	if win_is_open() then
		if vim.api.nvim_get_current_win() == state.win then
			vim.api.nvim_win_hide(state.win)
			state.win = -1
		else
			vim.api.nvim_set_current_win(state.win)
			vim.cmd.startinsert()
		end
		return
	end

	open_split()
	if not job_is_running() then
		start_shell()
	end
	vim.cmd.startinsert()
end

---------------------------------------------------------------------------
-- Floating terminal
---------------------------------------------------------------------------

---@param opts? { width?: number, height?: number }
function M.float_term(opts)
	opts = opts or {}

	local max_w = vim.o.columns - 2 -- room for the border
	local max_h = vim.o.lines - vim.o.cmdheight - 2

	local width = math.min(opts.width or math.floor(vim.o.columns * 0.8), max_w)
	local height = math.min(opts.height or math.floor(vim.o.lines * 0.8), max_h)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe" -- don't leave the dead terminal buffer behind

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width - 2) / 2),
		row = math.floor((max_h + 2 - height - 2) / 2),
		style = "minimal",
		border = "rounded",
	})

	spawn_shell(function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end)

	vim.cmd.startinsert()
	return buf, win
end

---------------------------------------------------------------------------
-- Utilities
---------------------------------------------------------------------------

---Add (`"x"`, default) or remove (`"-x"` / anything else) the executable bit on the current file.
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
