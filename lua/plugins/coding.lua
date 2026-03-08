return {
	-- NOTE: Git wrapper for vim/neovim
	{
		"tpope/vim-fugitive",
		event = "BufReadPre",
		config = function()
			vim.keymap.set("n", "<leader>gs", "<CMD>Git status<CR>", { desc = "Git Status" })
			vim.keymap.set("n", "<leader>ga", "<CMD>Git add<CR>", { desc = "Git Add" })
			vim.keymap.set("n", "<leader>gce", "<CMD>Git commit --edit<CR>", { desc = "Git Commit (edit)" })
			vim.keymap.set("n", "<leader>gca","<CMD>Git commit --amend<CR>", { desc = "Git Commit (amend)" })
			vim.keymap.set("n", "<leader>gp", "<CMD>Git pull --no-edit<CR>", { desc = "Git Pull (No Edit)" })
			vim.keymap.set("n", "<leader>gP", "<CMD>Git push<CR>", { desc = "Git Push" })
		end
	}
}
