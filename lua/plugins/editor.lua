local base_utils = require("utils.base")
return {
	-- NOTE: A plugin for undo files checking
	{
		"mbbill/undotree",
		event = "BufReadPre",
		keys = {
			{
				"<leader>uu",
				"<CMD>UndotreeToggle<CR>",
				desc = "Undotree Toggle",
			},
		},
	},
	-- NOTE: Telescope.nvim (finder, picker etc)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local keymap = vim.keymap
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			local themes = require("telescope.themes")
			local extensions = telescope.extensions
			local fb_actions = extensions.file_browser.actions

			-- Builtin keymaps
			keymap.set("n", "<leader><space>", builtin.find_files, { desc = "Telescop -> Find Files" })
			keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope -> Live Grep" })
			keymap.set("n", "<leader>,", builtin.buffers, { desc = "Telescope -> Buffers" })
			keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope -> Help Tags" })
			keymap.set("n", "<leader>sm", builtin.man_pages, { desc = "Telescope -> Man Pages" })
			keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Telescope -> Keymaps" })
			keymap.set("n", "<leader>:", builtin.command_history, { desc = "Telescope -> Command History" })
			keymap.set("n", "<leader>xf", builtin.diagnostics, { desc = "Telescop -> Diagnostics" })

			keymap.set("n", "<leader>uC", function()
				builtin.colorscheme({ enable_preview = true })
			end, { desc = "Colorscheme" })

			-- Neovim Config file keymap
			keymap.set("n", "<leader>fc", function()
				require("telescope.builtin").find_files({
					prompt_title = "Neovim Config Files",
					cwd = vim.fn.stdpath("config"),
				})
			end, { desc = "Neovim Config Files" })

			-- Intelligent find file function
			keymap.set("n", "<leader>sf", function()
				extensions.frecency.frecency({
					prompt_title = "Find Files",
					cwd = base_utils.project_root(),
					workspace = "CWD",
					hidden = true,
				})
			end, { desc = "Telescope -> Find files" })

			-- Telescope file browser
			keymap.set("n", "sf", function()
				local function telescope_buffer_dir()
					return vim.fn.expand("%:p:h")
				end

				extensions.file_browser.file_browser({
					path = "%:p:h",
					cwd = telescope_buffer_dir(),
					respect_gitignore = true,
					hidden = true,
					follow_symlinks = true,
					grouped = true,
					previewer = true,
					initial_mode = "normal",
					-- layout_config = {
					-- 	height = 0.60,
					-- },
				})
			end, { desc = "File Browser" })

			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"%.git/",
						"node_modules",
						-- "%.git$",
					},
					wrap_results = true,
					layout_stategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							previewer_width = 0.55,
						},
						width = 0.87,
						height = 0.80,
					},
					sorting_strategy = "ascending",
					winblend = 0,
					mappings = {
						n = {
							["q"] = actions.close,
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						case_mode = "smart_case",
					},
					file_browser = {
						-- theme = "ivy",
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = true,
						mappings = {
							-- your custom insert mode mappings
							["n"] = {
								-- your custom normal mode mappings
								["N"] = fb_actions.create,
								["h"] = fb_actions.goto_parent_dir,
								["q"] = actions.close,
								["H"] = fb_actions.toggle_hidden,
								["/"] = function()
									vim.cmd("startinsert")
								end,
								["<C-u>"] = function(prompt_bufnr)
									for i = 1, 10 do
										actions.move_selection_previous(prompt_bufnr)
									end
								end,
								["<C-d>"] = function(prompt_bufnr)
									for i = 1, 10 do
										actions.move_selection_next(prompt_bufnr)
									end
								end,
								["<PageUp>"] = actions.preview_scrolling_up,
								["<PageDown>"] = actions.preview_scrolling_down,
							},
						},
					},
					frecency = {
						db_safe_mode = false,
						db_validate_threshold = 0,
						show_filter_column = false,
					},
					["ui-select"] = themes.get_dropdown({}),
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
			telescope.load_extension("ui-select")
			telescope.load_extension("frecency")
		end,
	},

	-- NOTE: Buffer closing plugin
	{
		"kazhala/close-buffers.nvim",
		event = "BufReadPre",
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
				desc = "Close Current Buffer",
			},
			{
				"<leader>bu",
				function()
					require("close_buffers").delete({ type = "nameless" })
				end,
				desc = "Close Nameless Buffers",
			},
		},
	},

	-- NOTE: Better increase/descrease
	{
		"monaqa/dial.nvim",
		event = "BufReadPre",
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

	-- NOTE: Session Management
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
	},
}
