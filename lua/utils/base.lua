local state = {
	buf = -1,
	win = -1,
	job_id = -1,
	height_fraction = 0.4,
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
		state.job_id = vim.fn.jobstart(vim.o.shell, {
			term = true,
			on_exit = function(_, code, _)
				vim.schedule(function()
					-- Guard: only close if the window is still showing our terminal buffer
					if vim.api.nvim_win_is_valid(state.win) and vim.api.nvim_win_get_buf(state.win) == state.buf then
						vim.api.nvim_win_hide(state.win)
					end
					state.win = -1
					state.job_id = -1
					-- Clean up the buffer so next toggle starts fresh
					if vim.api.nvim_buf_is_valid(state.buf) then
						vim.api.nvim_buf_delete(state.buf, { force = true })
						state.buf = -1
					end
					if code ~= 0 then
						vim.notify("Terminal exited with code " .. code, vim.log.levels.WARN, { title = "Terminal" })
					end
				end)
			end,
		})
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
