local state = {
	buf = -1,
	win = -1,
	job_id = -1,
	height_fraction = 0.35,
}

local M = {}

-- A lua function to toggle terminal horizontally
function M.toggle_terminal()
	-- If the window exists and is valid, hide it
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = -1
		return
	end

	-- Calculate the terminal height as a fraction of the screen
	local total_height = vim.o.lines
	local term_height = math.max(1, math.floor(total_height * state.height_fraction))

	-- Create or reuse buffer
	if not vim.api.nvim_buf_is_valid(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Open the window at the bottom
	vim.cmd("botright split")
	state.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_height(state.win, term_height)
	vim.api.nvim_win_set_buf(state.win, state.buf)

	-- Restart the terminal only if there is no live job (covers dead/exited shells)
	local job_running = state.job_id ~= -1 and vim.fn.jobwait({ state.job_id }, 0)[1] == -1
	if not job_running then
		state.job_id = vim.fn.jobstart(vim.o.shell, { term = true })
		vim.wo[state.win].number = false
		vim.wo[state.win].relativenumber = false
		vim.wo[state.win].signcolumn = "no"
	end

	-- Enter insert mode automatically
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

return M
