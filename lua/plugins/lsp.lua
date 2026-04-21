return {
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
				default = { "lsp", "path", "snippets", "buffer", "emoji" },
				providers = {
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
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
