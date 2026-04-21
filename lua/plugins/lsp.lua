return {
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

	{
		"saghen/blink.cmp",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
			"moyiz/blink-emoji.nvim",
			"saghen/blink.compat",
		},
		opts = {
			keymap = {
				preset = "default",
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept_and_enter", "fallback" },
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer", "emoji" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 150, -- Tune by preference
						opts = { insert = true }, -- Insert emoji (default) or complete its name
					},
				},
			},
			cmdline = {
				enabled = false,
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				trigger = {
					prefetch_on_insert = true,
				},
				ghost_text = {
					enabled = true,
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = true,
					},
				},
			},
			fuzzy = { implementation = "lua" },
		},
	},
}
