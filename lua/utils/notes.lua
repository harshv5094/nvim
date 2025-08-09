local M = {}

local Path = require("plenary.path")
local scan = require("plenary.scandir")
local builtin = require("telescope.builtin")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local notes_dir = vim.fn.expand("~/notebook")
local templates_dir = vim.fn.expand("~/notebook/.templates")

-- Get today's date
local function get_current_date()
	return os.date("%d/%m/%Y %I:%M %p")
end

-- 1. Create a new Markdown note using selected template
M.create_note = function()
	vim.ui.input({ prompt = "Note Title: " }, function(title)
		if not title or title == "" then
			return
		end

		-- Format title to "Me Mo Mi" style
		local function format_title(str)
			return str
				:gsub("[-_]", " ") -- replace hyphens or underscores with space
				:gsub("(%a)([%w_']*)", function(a, b)
					return a:upper() .. b:lower()
				end)
		end

		local formatted_title = format_title(title)

		-- Scan templates directory for .md files
		local template_files = scan.scan_dir(templates_dir, { depth = 1, search_pattern = "%.md$" })

		-- Remove full path to display just filenames
		local entries = {}
		for _, file in ipairs(template_files) do
			table.insert(entries, vim.fn.fnamemodify(file, ":t"))
		end

		-- Launch Telescope picker for templates
		pickers
			.new({}, {
				prompt_title = "Select Template",
				finder = finders.new_table({
					results = entries,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					map("i", "<CR>", function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						if not selection then
							vim.notify("No template selected", vim.log.levels.WARN)
							return
						end

						local template_path = Path:new(templates_dir, selection[1])
						local new_note_path = Path:new(notes_dir, title:gsub("%s+", "_") .. ".md")

						-- Read template content
						local content = template_path:read()
						content = content:gsub("{{title}}", formatted_title):gsub("{{date}}", get_current_date())

						-- Write to new note if not exists
						if not new_note_path:exists() then
							new_note_path:write(content, "w")
						end

						vim.cmd("edit " .. new_note_path.filename)
					end)
					return true
				end,
			})
			:find()
	end)
end

-- 2. Search notes by tag (from the YAML frontmatter)
M.search_by_tag = function()
	vim.ui.input({ prompt = "Search tag:" }, function(tag)
		if not tag or tag == "" then
			return
		end
		builtin.grep_string({
			search = "tags:.*" .. tag,
			cwd = notes_dir,
			use_regex = true,
		})
	end)
end

-- 3. Find notes in the notes dir
M.find_notes = function()
	builtin.find_files({
		prompt_title = "Find Notes",
		cwd = notes_dir,
	})
end

-- 4. Sync notes to all remotes with stash, pull, and push
M.sync_to_remote = function()
	-- Generate a timestamped commit message
	local timestamp = os.date("%d/%m/%Y %I:%M %p")
	local commit_msg = "backup: " .. timestamp

	-- Shell command to run Git operations in sequence
	local cmd = {
		"sh",
		"-c",
		table.concat({
			-- Change directory to your notes folder
			"cd " .. notes_dir,

			-- Stash any local changes, including untracked files (-u)
			"git stash push -u -m 'auto-backup-stash'",

			-- Pull latest changes from the remote repo
			"git pull",

			-- Reapply your stashed local changes
			"git stash pop",

			-- Stage all changes (including new files)
			"git add .",

			-- Commit with a timestamped backup message
			"git commit -m '"
				.. commit_msg
				.. "'",

			-- Push to the remote repository (Only applies if you are using my gitconfig alias)
			-- TODO: Add a safety switch, if my git alias is not present there
			"git pushall",
		}, " && "),
	}

	-- Run the Git command asynchronously using vim.system (Neovim 0.10+)
	vim.system(cmd, { text = true }, function(result)
		if result.code == 0 then
			-- If the sync succeeded, notify the user
			vim.schedule(function()
				vim.notify("Notes synced to Remote: " .. commit_msg, vim.log.levels.INFO)
			end)
		else
			-- If there was an error, notify with stderr output
			vim.schedule(function()
				vim.notify("Git sync failed:\n" .. result.stderr, vim.log.levels.ERROR)
			end)
		end
	end)
end

return M
