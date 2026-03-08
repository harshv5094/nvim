return {
	-- NOTE: Basic treesitter installation plugin
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local parsers = {
				'bash',
				'vim',
				'vimdoc',
				'lua',
			}
			require("nvim-treesitter").install(parsers)
		end
	},

	-- NOTE: Top level treesitter context viewer
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		opts = {
			enable = true,
			multiwindow = false,
			mode = 'cursor',
			max_lines = 0,
			min_window_height = 0,
			multiline_threshold = 20,
			trim_scope = outer,
			zindex = 20,
			on_attach = nil,
			seperator = nil
		},
		config = function(_,opts)
			local ts_context = require("treesitter-context")
			ts_context.setup(opts)
		end
	},

	-- NOTE: Utility plugin to autoinstall treesitter parsers
	{
		"mks-h/treesitter-autoinstall.nvim",
		opts = {
			-- A list of *treesitter languages* to ignore.
			ignore = {},
    	-- Auto-enable highlighting for installed languages.
			highlight = true,
    	-- A list of *treesitter languages* to also enable regex highlighting for
			regex = {},
		},
		config = function (_,opts)
			require('treesitter-autoinstall').setup(opts)
		end
	}
}
