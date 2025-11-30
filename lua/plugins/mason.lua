return {
	-- NOTE: This is lsp installer config
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
			"mason-org/mason-registry",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				"bashls",
				"stylua",
			},
		},
		keys = {
			{
				"<leader>m",
				"<CMD>Mason<CR>",
				desc = "Mason",
			},
		},
	},
}
