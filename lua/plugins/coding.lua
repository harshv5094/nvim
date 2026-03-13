return {
	-- NOTE: Git wrapper for vim/neovim
	{
		"tpope/vim-fugitive",
		event = "BufReadPre",
		config = function()
			vim.keymap.set("n", "<leader>gs", "<CMD>Git status<CR>", { desc = "Git Status" })
			vim.keymap.set("n", "<leader>ga", ":Git add ", { desc = "Git Add" })
			vim.keymap.set("n", "<leader>gce", "<CMD>Git commit --edit<CR>", { desc = "Git Commit (edit)" })
			vim.keymap.set("n", "<leader>gca", "<CMD>Git commit --amend<CR>", { desc = "Git Commit (amend)" })
			vim.keymap.set("n", "<leader>gp", "<CMD>Git pull --no-edit<CR>", { desc = "Git Pull (No Edit)" })
			vim.keymap.set("n", "<leader>gP", "<CMD>Git push --force-with-lease<CR>", { desc = "Git Push" })
		end,
	},

	-- NOTE: Diagnostics panel from folke
	{
		"folke/trouble.nvim",
		event = "BufReadPre",
		cmd = "Trouble",
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>xt",
				"<cmd>Trouble todo toggle<cr>",
				desc = "Todo (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
		},
	},

	-- Keeping .env Secret
	{
		"laytan/cloak.nvim",
		event = "VeryLazy",
		config = function()
			require("cloak").setup({
				enabled = true,
				cloak_character = "*",
				-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
				highlight_group = "Comment",
				patterns = {
					{
						-- Match any file starting with ".env".
						-- This can be a table to match multiple file patterns.
						file_pattern = {
							".env*",
							"wrangler.toml",
							".dev.vars",
						},
						-- Match an equals sign and any character after it.
						-- This can also be a table of patterns to cloak,
						-- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
						cloak_pattern = "=.+",
					},
				},
			})
		end,
	},
}
