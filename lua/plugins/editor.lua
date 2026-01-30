return {

	-- Multiple close buffer plugin
	"kazhala/close-buffers.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>bh",
			function()
				require("close_buffers").delete({ type = "hidden" })
			end,
			desc = "Close Hidden Buffers",
		},
		{
			"<leader>bd",
			function()
				require("close_buffers").delete({ type = "this" })
			end,
		},
		{
			"<leader>bu",
			function()
				require("close_buffers").delete({ type = "nameless" })
			end,
			desc = "Close Nameless Buffers",
		},
	},

	-- Better increase/descrease
	{
		"monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }),
				},
			})
		end,
	},

	-- NOTE: Undo tree
	{
		"mbbill/undotree",
		event = { "BufReadPre" },
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, {
				desc = "Toggle Undotree",
			})
		end,
	},

	-- NOTE: Toggle Terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		keys = {
			{
				"<leader>ft",
				"<CMD>ToggleTerm<CR>",
				desc = "Toggle Terminal",
			},
		},
	},
}
