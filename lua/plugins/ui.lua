return {
	-- NOTE: todo comments highlighter plugin
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	},

	-- NOTE: Floating file name/statusline
	{
		"b0o/incline.nvim",
		event = "VeryLazy",	
		config = function()
			local incline = require("incline")
			incline.setup({
				debounce_threshold = {
					falling = 50,
					rising = 10,
				},
				hide = {
					cursorline = "smart",
					focused_win = false,
					only_win = false,
				},
				window = { padding = 0, margin = { vertical = 0, horizontal = 0 } },
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local modified = vim.bo[props.buf].modified

					-- No Name for unsaved file
					if filename == "" then
						filename = "[No Name]"
					end

					-- Adding plus sign for unsaved file
					if modified then
						filename = "[+] " .. filename
					end

					-- Determine styling: Bold only if focused
					-- Keeps italic if modified, regardless of focus
					local style = ""
					if props.focused then
						style = modified and "bold,italic" or "bold"
					else
						style = modified and "italic" or "none"
					end

					local design = {
						{ " " },
						{ filename, gui = style },
						{ " " },
					}
					return design
				end,
			})
		end
	},

	-- NOTE: Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")
			lualine.setup({
				options = {
					icons_enabled = true,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
					globalstatus = true, -- A single statusline for every window
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 	
						function()
							return " " .. os.date("%I:%M %p")
						end,
					},
				},
  			inactive_sections = {
    			lualine_a = {},
    			lualine_b = {},
    			lualine_c = {'filename'},
    			lualine_x = {'location'},
    			lualine_y = {},
    			lualine_z = {}
  			},
			})
		end
	}
}
