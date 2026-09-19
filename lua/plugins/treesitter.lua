return {
	-- NOTE: Basic treesitter installation plugin
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		-- Load after mason so the tree-sitter CLI (installed by
		-- mason-tool-installer) is on PATH before parsers install.
		dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
		config = function()
			local parsers = {
				"bash",
				"gitcommit",
				"gitignore",
				"git_config",
				"vim",
				"diff",
				"vimdoc",
				"lua",
				"luadoc",
			}
			local install_parsers = function()
				if vim.fn.executable("tree-sitter") == 1 then
					require("nvim-treesitter").install(parsers)
				else
					vim.notify(
						"tree-sitter CLI not found; skipping parser install",
						vim.log.levels.WARN,
						{ title = "nvim-treesitter" }
					)
				end
			end
			if vim.fn.executable("tree-sitter") == 1 then
				install_parsers()
			else
				-- tree-sitter-cli installs async via mason; retry once mason is done.
				vim.api.nvim_create_autocmd("User", {
					pattern = "MasonToolsUpdateCompleted",
					once = true,
					callback = install_parsers,
				})
			end
		end,
	},

	-- NOTE: Top level treesitter context viewer
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		opts = {
			mode = "cursor",
			max_lines = 3,
		},
		config = function(_, opts)
			local ts_context = require("treesitter-context")
			ts_context.setup(opts)
		end,
	},

	-- NOTE: Utility plugin to autoinstall treesitter parsers
	{
		"mks-h/treesitter-autoinstall.nvim",
		event = "BufReadPre",
		opts = {
			-- A list of *treesitter languages* to ignore.
			ignore = {},
			-- Auto-enable highlighting for installed languages.
			highlight = true,
			-- A list of *treesitter languages* to also enable regex highlighting for
			regex = {},
		},
		config = function(_, opts)
			require("treesitter-autoinstall").setup(opts)
		end,
	},
}
