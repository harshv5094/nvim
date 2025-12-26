return {

	-- NOTE: Hiding env secrets
	{
		"laytan/cloak.nvim",
		event = { "BufReadPre", "BufNewFile" },
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

	-- NOTE: Batteries included autocompletion
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "2.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				-- follow latest release.
				version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!).
				build = "make install_jsregexp",
			},
		},
		opts = {
			keymap = {
				["<CR>"] = { "accept", "fallback" },
				["<C-\\>"] = { "hide", "fallback" },
				["<C-n>"] = { "select_next", "show" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<C-p>"] = { "select_prev" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			completion = {
				list = {
					-- Insert items while navigating the completion list.
					selection = { preselect = true, auto_insert = true },
					max_items = 10,
				},
				documentation = { auto_show = true },
			},
			snippets = { preset = "luasnip" },
			-- Disable command line completion:
			cmdline = { enabled = false },
			sources = {
				-- Disable some sources in comments and strings.
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
			fuzzy = { implementation = "lua" },
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)

			-- Extend neovim's client capabilities with the completion ones.
			vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
		end,
	},

	-- NOTE: Vim Documentation API
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
