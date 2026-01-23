return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- Use the main branch for the latest features/rewrite
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			-- 1. Filetype Detection (Always use Neovim's built-in API)
			vim.filetype.add({
				extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
				filename = { ["vifmrc"] = "vim" },
				pattern = {
					[".*/waybar/config"] = "jsonc",
					[".*/mako/config"] = "dosini",
					[".*/kitty/.+%.conf"] = "bash",
					[".*/hypr/.+%.conf"] = "hyprlang",
					["%.env%.[%w_.-]+"] = "sh",
				},
			})

			-- 2. Define and Install Parsers
			local parsers = { "lua", "vim", "vimdoc", "bash", "markdown", "markdown_inline", "json", "zsh" }

			-- Helper to check binaries
			local function have(bin)
				return vim.fn.executable(bin) == 1
			end
			if have("fish") then
				table.insert(parsers, "fish")
			end
			if have("hyprctl") then
				table.insert(parsers, "hyprlang")
			end

			-- NEW API: Use the install function directly
			-- This is cleaner than the old nested setup table
			ts.install(parsers)
		end,
	},
}
