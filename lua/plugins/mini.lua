return {
	-- NOTE: Showing indent lines in the buffers
	{
		"nvim-mini/mini.indentscope",
		event = "BufReadPre",
		version = false,
		config = function()
			require("mini.indentscope").setup()
		end,
	},

	-- NOTE: Pairing plugin for [], {} and ()
	{
		"nvim-mini/mini.pairs",
		event = "InsertEnter",
		version = false,
		config = function()
			require("mini.pairs").setup()
		end,
	},

	-- NOTE: Mini Icons library
	{
		"nvim-mini/mini.icons",
		event = "VeryLazy",
		version = false,
		config = function()
			require("mini.icons").setup()
		end,
	},

	-- NOTE: Notification plugin
	{
		"nvim-mini/mini.notify",
		version = false,
		event = "VeryLazy",
		config = function()
			require("mini.notify").setup({
				lsp_progress = {
					enable = false,
				},
			})
			vim.keymap.set("n", "<Leader>n", function()
				vim.cmd("tabedit")
				MiniNotify.show_history()
			end, { desc = "Notification history" })
		end,
	},
}
