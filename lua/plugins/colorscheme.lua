return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent_mode = true,
		undercurl = true,
		underline = true,
		italic = {
			strings = false,
			emphasis = false,
			comments = false,
			operators = false,
			folds = false,
		},
	},
	config = function(_, opts)
		require("gruvbox").setup(opts)
	end,
}
