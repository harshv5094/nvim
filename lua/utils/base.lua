local state = {
	buf = -1,
	win = -1,
	job_id = -1,
	height_fraction = 0.4,
}

local M = {}

function M.toggle_terminal()
	-- Hide the terminal window if it's open
	local win = vim.fn.bufwinid(state.buf)
	if win ~= -1 then
		vim.api.nvim_win_hide(win)
		return
	end

	local height = math.max(1, math.floor(vim.o.lines * state.height_fraction))

	-- Create the buffer on first use or after the shell has exited
	local fresh = not vim.api.nvim_buf_is_valid(state.buf)
	if fresh then
		state.buf = vim.api.nvim_create_buf(false, true)
	end

	-- Open the split at the bottom and show the terminal buffer in it
	vim.cmd("botright split")
	vim.api.nvim_win_set_buf(0, state.buf)
	vim.api.nvim_win_set_height(0, height)
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.signcolumn = "no"

	if fresh or vim.bo[state.buf].channel == 0 then
		vim.api.nvim_buf_call(state.buf, function()
			vim.fn.jobstart(vim.o.shell, {
				term = true,
				on_exit = function(_, code)
					vim.schedule(function()
						-- Deleting the buffer closes any window showing it
						if vim.api.nvim_buf_is_valid(state.buf) then
							vim.api.nvim_buf_delete(state.buf, { force = true })
						end
						if code ~= 0 then
							vim.notify("Terminal exited with code " .. code, vim.log.levels.WARN, { title = "Terminal" })
						end
					end)
				end,
			})
		end)
	end

	vim.cmd("startinsert")
end

-- A lua function to change the current buffer to executable permission
function M.chmod(mode)
	mode = mode or "x"
	local file = vim.fn.expand("%")
	local sign = mode == "x" and "+" or "-"
	local result = os.execute("chmod " .. sign .. "x " .. vim.fn.shellescape(file))

	if result == 0 then
		vim.notify(
			"chmod " .. sign .. "x → " .. vim.fn.fnamemodify(file, ":t"),
			vim.log.levels.INFO,
			{ title = "File Permissions" }
		)
	else
		vim.notify(
			"Failed to chmod " .. sign .. "x → " .. vim.fn.fnamemodify(file, ":t"),
			vim.log.levels.ERROR,
			{ title = "File Permissions" }
		)
	end
end

function M.lazygit_toggle()
	-- Hide the float if it's already open
	for _, w in ipairs(vim.api.nvim_list_wins()) do
		if vim.w[w].lazygit then
			vim.api.nvim_win_hide(w)
			return
		end
	end

	-- Usable rows: total minus cmdline, tabline, and statusline
	local tabline = vim.o.showtabline > 0 and 1 or 0
	local statusline = vim.o.laststatus > 0 and 1 or 0
	local rows = vim.o.lines - vim.o.cmdheight - tabline - statusline

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(rows * 0.8)

	-- Reuse the buffer (and running lazygit) if it still exists
	local buf = vim.g.lazygit_buf
	local fresh = not (buf and vim.api.nvim_buf_is_valid(buf))
	if fresh then
		buf = vim.api.nvim_create_buf(false, true)
		vim.g.lazygit_buf = buf
		-- Deleting the buffer also closes any window showing it
		vim.api.nvim_create_autocmd("TermClose", {
			buffer = buf,
			once = true,
			callback = function()
				vim.g.lazygit_buf = nil
				vim.api.nvim_buf_delete(buf, { force = true })
			end,
		})
	end

	-- The border adds 2 rows and 2 columns outside width and height
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = tabline + math.floor((rows - height - 2) / 2),
		col = math.floor((vim.o.columns - width - 2) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.w[win].lazygit = true

	if fresh then
		vim.fn.jobstart({ "lazygit" }, { term = true })
	else
		-- Match the terminal's PTY size to the float on every reopen
		vim.fn.jobresize(vim.bo[buf].channel, width, height)
	end

	vim.cmd("startinsert")
end

-- A lua function to get project root dir path (whether you are in git path or not)
function M.project_root()
	return vim.fs.root(0, { ".git" }) or vim.fs.root(vim.fn.getcwd(), { ".git" }) or vim.fn.getcwd()
end

return M
