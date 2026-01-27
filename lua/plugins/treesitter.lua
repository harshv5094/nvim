return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			local parsers = {
				"lua",
				"vim",
				"vimdoc",
				"bash",
				"markdown",
				"markdown_inline",
				"python",
				"json",
				"zsh",
				"bash",
				"fish",
			}

			ts.install(parsers)
		end,
	},

	{
		"mks-h/treesitter-autoinstall.nvim",
		config = function()
			require("treesitter-autoinstall").setup({
				ignore = {},
				highlight = true,
				regex = {},
			})
		end,
	},
}
