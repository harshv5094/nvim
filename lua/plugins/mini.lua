return {
	-- NOTE: Showing indent lines in the buffers
	{
		"nvim-mini/mini.indentscope",
		event = "BufReadPre",
		version = false,
		config = function()
			require("mini.indentscope").setup()
		end,
	},

	-- NOTE: Pairing plugin for [], {} and ()
	{
		"nvim-mini/mini.pairs",
		event = "BufReadPre",
		version = false,
		config = function()
			require("mini.pairs").setup()
		end,
	},

	-- NOTE: Mini Icons library
	{
		"nvim-mini/mini.icons",
		version = false,
		config = function()
			require("mini.icons").setup()
		end,
	},
}
