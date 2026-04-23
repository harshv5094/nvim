return {
	{
		"folke/snacks.nvim",
		cmd = "Snacks",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			statuscolumn = { enabled = true },
			indent = { enabled = true },
			lazygit = { enabled = true },
			zen = { enabled = true },
		},
		keys = {
			{
				"<c-/>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Toggle Zen Mode",
			},
			{
				"<leader>Z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
		},
	},
}
