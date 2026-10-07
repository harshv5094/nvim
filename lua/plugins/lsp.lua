return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	--NOTE: When shifting to v2 blink.lib is necessary uncomment it later after stable release
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			-- "saghen/blink.lib",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
			cmdline = {
				enabled = true,
			},
			signature = {
				enabled = true,
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
			},
			fuzzy = { implementation = "prefer_rust" },
		},
	},

	-- NOTE: Mason
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		config = function()
			---@type MasonSettings
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
				desc = "Mason",
			},
		},
	},

	-- NOTE: Auto installer for mason.nvim
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			---@type MasonToolInstallerSettings
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Installed first: required by nvim-treesitter to
					-- compile/install parsers (see plugins/treesitter.lua).
					{ "tree-sitter-cli", auto_update = true },

					-- LSP servers
					"lua-language-server",
					"bash-language-server",
					"yaml-language-server",
					"json-lsp",
					"taplo",

					-- Formatters / linters
					"stylua",
					"shellcheck",
					"shfmt",
					"luacheck",
				},
			})
		end,
	},
}
