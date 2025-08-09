return {
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
			"<leader>bu",
			function()
				require("close_buffers").delete({ type = "nameless" })
			end,
			desc = "Close Nameless Buffers",
		},
		{
			"<leader>bd",
			function()
				require("close_buffers").delete({ type = "this" })
			end,
			desc = "Close Nameless Buffers",
		},
	},
}
