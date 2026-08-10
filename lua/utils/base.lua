local state = {
	buf = -1,
	win = -1,
	screen_width = 0.35,
}

local M = {}

-- A lua function to toggle terminal horizontally
function M.toggle_terminal()
	-- If the window exists and is valid, hide it
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		return
	end

	-- Calculate 35% of total screen height
	local total_height = vim.o.lines
	local term_height = math.floor(total_height * state.screen_width)

	-- Create or reuse buffer
	if not vim.api.nvim_buf_is_valid(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Open the window at the bottom
	vim.cmd("botright split")
	state.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_height(state.win, term_height)
	vim.api.nvim_win_set_buf(state.win, state.buf)

	-- Start terminal if it's a new buffer
	if vim.bo[state.buf].buftype ~= "terminal" then
		vim.fn.jobstart(vim.o.shell, { term = true })
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
