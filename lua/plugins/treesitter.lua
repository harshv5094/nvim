return {
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
