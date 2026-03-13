return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
		opts = {
			terminal_colors = true,
			undercurl = true,
			bold = true,
			italic = {
				strings = false,
				emphasis = false,
				comments = true,
				operators = false,
				folds = true,
			},
		},
		config = function(_, opts)
			require("gruvbox").setup(opts)
			vim.cmd("colorscheme gruvbox")
		end,
	},
}
