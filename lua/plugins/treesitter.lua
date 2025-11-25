return {
	-- NOTE: Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			-- Helper to check if an executable exists
			local function have(bin)
				return vim.fn.executable(bin) == 1
			end

			-- Custom filetype detection
			vim.filetype.add({
				extension = {
					rasi = "rasi", -- rofi/wofi themes
					rofi = "rasi",
					wofi = "rasi",
				},
				filename = {
					["vifmrc"] = "vim", -- vifm config as vimscript
				},
				pattern = {
					[".*/waybar/config"] = "jsonc",
					[".*/mako/config"] = "dosini",
					[".*/kitty/.+%.conf"] = "kitty",
					[".*/hypr/.+%.conf"] = "hyprlang",
					["%.env%.[%w_.-]+"] = "sh",
				},
			})

			-- Map kitty configs to bash parser
			vim.treesitter.language.register("bash", "kitty")

			-- Base parsers always installed
			local parsers = {
				"lua",
				"vim",
				"bash",
				"markdown",
				"markdown_inline",
				"git_config",
			}

			-- Add parsers conditionally based on tools installed
			if have("fish") then
				table.insert(parsers, "fish")
			end
			if have("hyprctl") or have("hyprland") or have("hypr") then
				table.insert(parsers, "hyprlang")
			end
			if have("rofi") or have("wofi") then
				table.insert(parsers, "rasi")
			end

			require("nvim-treesitter.configs").setup({
				ensure_installed = parsers,
				auto_install = true, -- install parsers for opened files
				sync_install = false,

				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							vim.notify(
								"File larger than 100KB, Treesitter disabled for performance",
								vim.log.levels.WARN,
								{ title = "Treesitter" }
							)
							return true
						end
					end,
					additional_vim_regex_highlighting = { "markdown" },
				},

				indent = { enable = true },
			})
		end,
	},
}
