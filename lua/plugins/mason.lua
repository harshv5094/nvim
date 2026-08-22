return {
	{
		"mason-org/mason.nvim",
		version = "v2.*",
		cmd = "Mason",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
		keys = {
			{
				"<leader>cm",
				"<CMD>Mason<CR>",
				{ desc = "Mason" },
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP servers
					"lua-language-server",
					"bash-language-server",
					"yaml-language-server",
					"taplo",

					-- Formatters / linters
					"stylua",
					"shellcheck",
					"shfmt",
				},
				automatic_installation = true,
				run_on = { "BufReadPre", "VeryLazy" },
			})
		end,
	},
}
