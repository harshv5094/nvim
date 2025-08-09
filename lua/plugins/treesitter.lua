return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"bash",
				"fish",
				"typescript",
				"python",
				"go",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
			},
			auto_install = true,
			sync_install = false,
			highlight = {
				enabled = true,
			},
			indent = {
				enabled = true,
			},
		})
	end,
}
