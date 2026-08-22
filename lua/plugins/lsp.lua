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
		event = { "InsertEnter" },
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			-- "saghen/blink.lib",
			"moyiz/blink-emoji.nvim",
			"saghen/blink.compat",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept_and_enter", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
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

	-- NOTE: Mason
	{
		"mason-org/mason.nvim",
		version = "*", -- Installs the latest stable release of mason
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

	-- NOTE: Auto installer for mason.nvim
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
