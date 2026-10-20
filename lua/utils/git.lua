local M = {}

local uv = vim.uv or vim.loop

-- NOTE: Rewrite rules that turn a git remote into a browsable HTTPS URL.
-- Order matters: the more specific patterns must come first.
---@type { [1]: string, [2]: string }[]
M.remote_patterns = {
	{ "^(https?://.*)%.git$", "%1" },
	{ "^git@(.+):(.+)%.git$", "https://%1/%2" },
	{ "^git@(.+):(.+)$", "https://%1/%2" },
	{ "^git@(.+)/(.+)$", "https://%1/%2" },
	{ "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
	{ "^ssh://git@(.*)$", "https://%1" },
	{ "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
	{ "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
	{ "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
	{ "^https://%w*@(.*)", "https://%1" },
	{ "^git@(.*)", "https://%1" },
	{ ":%d+", "" },
	{ "%.git$", "" },
}

---@class utils.git.Fields
---@field branch? string
---@field file? string
---@field commit? string
---@field line_start? integer
---@field line_end? integer
---@field line_count? integer

-- NOTE: Format the `#Lx-Ly` part of a URL (GitHub/GitLab style).
---@param fields utils.git.Fields
---@return string
local function line_suffix(fields)
	if not fields.line_start then
		return ""
	end
	if not fields.line_end or fields.line_end == fields.line_start then
		return "#L" .. fields.line_start
	end
	return ("#L%s-L%s"):format(fields.line_start, fields.line_end)
end

-- NOTE: Format the `#lines-x:y` part of a Bitbucket URL.
---@param fields utils.git.Fields
---@return string
local function bitbucket_suffix(fields)
	if not fields.line_start then
		return ""
	end
	if not fields.line_end or fields.line_end == fields.line_start then
		return "#lines-" .. fields.line_start
	end
	return ("#lines-%s:%s"):format(fields.line_start, fields.line_end)
end

-- NOTE: Host specific URL paths for each browse target.
-- A target can be a template string or a function returning the path.
---@type table<string, table<string, string|fun(fields: utils.git.Fields): string>>
M.url_patterns = {
	["github%.com"] = {
		branch = "/tree/{branch}",
		file = function(fields)
			return "/blob/" .. fields.branch .. "/" .. fields.file .. line_suffix(fields)
		end,
		permalink = function(fields)
			return "/blob/" .. fields.commit .. "/" .. fields.file .. line_suffix(fields)
		end,
		commit = "/commit/{commit}",
	},
	["gitlab%.com"] = {
		branch = "/-/tree/{branch}",
		file = function(fields)
			return "/-/blob/" .. fields.branch .. "/" .. fields.file .. line_suffix(fields)
		end,
		permalink = function(fields)
			return "/-/blob/" .. fields.commit .. "/" .. fields.file .. line_suffix(fields)
		end,
		commit = "/-/commit/{commit}",
	},
	["bitbucket%.org"] = {
		branch = "/src/{branch}",
		file = function(fields)
			return "/src/" .. fields.branch .. "/" .. fields.file .. bitbucket_suffix(fields)
		end,
		permalink = function(fields)
			return "/src/" .. fields.commit .. "/" .. fields.file .. bitbucket_suffix(fields)
		end,
		commit = "/commits/{commit}",
	},
	["git.sr.ht"] = {
		branch = "/tree/{branch}",
		file = function(fields)
			return "/tree/" .. fields.branch .. "/item/" .. fields.file .. line_suffix(fields)
		end,
		permalink = function(fields)
			return "/tree/" .. fields.commit .. "/item/" .. fields.file .. line_suffix(fields)
		end,
		commit = "/commit/{commit}",
	},
}

---Run a git command in a directory.
---@param args string[]
---@param cwd string
---@return string[] lines
---@return boolean ok
local function git(args, cwd)
	if not cwd or uv.fs_stat(cwd) == nil then
		return {}, false
	end

	local cmd = { "git", "-C", cwd }
	vim.list_extend(cmd, args)
	local out = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		return {}, false
	end
	return vim.split(vim.trim(out), "\n", { trimempty = true }), true
end

---Return the current buffer's on-disk path (oil buffers supported).
---@return string? path
---@return boolean is_file
local function buf_path()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return nil, false
	end

	name = vim.fs.normalize((name:gsub("^oil://", "")))
	local stat = uv.fs_stat(name)
	if not stat then
		return nil, false
	end
	return name, stat.type == "file"
end

---Get the root of the git repository for the current buffer.
---@return string? root
function M.root()
	local path, is_file = buf_path()
	local start
	if path then
		start = is_file and vim.fn.fnamemodify(path, ":h") or path
	else
		start = uv.cwd() or vim.fn.getcwd()
	end

	local out = git({ "rev-parse", "--show-toplevel" }, start)
	return out[1] and vim.fs.normalize(out[1]) or nil
end

-- This function allows user to setup git initialized on the root directory where neovim is open.
function M.init()
	local root = vim.fn.getcwd()
	local output = vim.fn.system({ "git", "init", root })

	if vim.v.shell_error == 0 then
		vim.notify("Git initialized in: " .. root, vim.log.levels.INFO, { title = "Git Init" })
	else
		vim.notify("Git init failed:\n" .. output, vim.log.levels.ERROR, { title = "Git Init Error" })
	end
end

---Normalize a git remote (ssh or https) into a browsable repository URL.
---@param remote string
---@return string
function M.get_repo(remote)
	local ret = remote
	for _, pattern in ipairs(M.remote_patterns) do
		ret = ret:gsub(pattern[1], pattern[2])
	end
	return ret:find("https://", 1, true) == 1 and ret or ("https://" .. ret)
end

---Build the URL for a repository and a set of fields.
---@param repo string
---@param fields utils.git.Fields
---@param what "repo"|"branch"|"file"|"commit"|"permalink"
---@return string
function M.get_url(repo, fields, what)
	for host, targets in pairs(M.url_patterns) do
		if repo:find(host) then
			local pattern = targets[what]
			if type(pattern) == "string" then
				return repo .. pattern:gsub("(%b{})", function(key)
					return tostring(fields[key:sub(2, -2)] or key)
				end)
			elseif type(pattern) == "function" then
				return repo .. pattern(fields)
			end
		end
	end
	return repo
end

---@class utils.git.BrowseOpts
---@field what? "repo"|"branch"|"file"|"commit"|"permalink"
---@field remote? string
---@field branch? string
---@field file? string
---@field commit? string
---@field line_start? integer
---@field line_end? integer

---Resolve the current buffer into the fields used to build a browse URL.
---@param opts utils.git.BrowseOpts
---@return { root: string, fields: utils.git.Fields, what: string }?
local function resolve(opts)
	local root = M.root()
	if not root then
		return nil
	end

	local path, is_file = buf_path()

	-- Only tracked files can be linked; everything else falls back to the branch/repo.
	local file = opts.file
	if not file and path and is_file then
		file = git({ "ls-files", "--full-name", "--", path }, root)[1]
	end

	local branch = opts.branch or git({ "rev-parse", "--abbrev-ref", "HEAD" }, root)[1]
	if branch == "HEAD" then
		branch = nil -- detached HEAD
	end

	local commit = opts.commit
	if not commit then
		local word = vim.fn.expand("<cword>")
		if #word >= 7 and word:match("^%x+$") then
			local _, ok = git({ "cat-file", "-e", word .. "^{commit}" }, root)
			commit = ok and word or nil
		end
	end

	local what = opts.what or "file"
	if what == "permalink" and not commit and file then
		commit = git({ "log", "-n", "1", "--pretty=format:%H", "--", file }, root)[1]
	end

	-- Line ranges, either passed in or taken from the current (visual) selection.
	local line_start, line_end = opts.line_start, opts.line_end
	if not line_start and vim.fn.mode():find("[vV\22]") then
		local anchor, cursor = vim.fn.line("v"), vim.fn.line(".")
		if anchor > 0 and cursor > 0 then
			line_start, line_end = math.min(anchor, cursor), math.max(anchor, cursor)
		end
	end
	if not line_start and file then
		local cursor = vim.fn.line(".")
		if cursor > 0 then
			line_start = cursor
		end
	end
	if line_start and not line_end then
		line_end = line_start
	end

	-- Downgrade to the closest target that actually has the required info.
	if what == "commit" or what == "permalink" then
		if not commit then
			what = file and "file" or "branch"
		end
	end
	if what == "file" and not file then
		what = branch and "branch" or "repo"
	end
	if what == "branch" and not branch then
		what = "repo"
	end

	---@type utils.git.Fields
	local fields = {
		branch = branch,
		file = file,
		commit = commit,
		line_start = (what == "file" or what == "permalink") and line_start or nil,
		line_end = (what == "file" or what == "permalink") and line_end or nil,
	}
	fields.line_count = fields.line_start and fields.line_end and (fields.line_end - fields.line_start + 1) or nil

	return { root = root, fields = fields, what = what }
end

---Get the browse URL for every remote of the current repository.
---@param opts? utils.git.BrowseOpts
---@return { name: string, url: string }[]
function M.remotes(opts)
	opts = opts or {}
	local ctx = resolve(opts)
	if not ctx then
		return {}
	end

	local remotes = {}
	for _, line in ipairs(git({ "remote", "-v" }, ctx.root)) do
		local name, remote = line:match("^(%S+)%s+(%S+)%s+%(fetch%)$")
		if name and (not opts.remote or opts.remote == name) then
			table.insert(remotes, {
				name = name,
				url = M.get_url(M.get_repo(remote), ctx.fields, ctx.what),
			})
		end
	end
	return remotes
end

---Get the browse URL for the current file/line, branch, commit or repository.
---@param opts? utils.git.BrowseOpts
---@return string? url
function M.url(opts)
	local remotes = M.remotes(opts)
	return remotes[1] and remotes[1].url or nil
end

---Open the current file/line, branch, commit or repository in the browser.
---@param opts? utils.git.BrowseOpts
function M.browse(opts)
	opts = opts or {}

	if not M.root() then
		vim.notify("Not inside a git repository", vim.log.levels.WARN, { title = "Git Browse" })
		return
	end

	local remotes = M.remotes(opts)

	if #remotes == 0 then
		vim.notify("No git remote found for this repository", vim.log.levels.WARN, { title = "Git Browse" })
		return
	end

	local function open(remote)
		if not remote then
			return
		end

		vim.notify("Opening " .. remote.url, vim.log.levels.INFO, { title = "Git Browse" })
		local handle, err = vim.ui.open(remote.url)
		if not handle then
			vim.notify("Failed to open URL:\n" .. tostring(err), vim.log.levels.ERROR, { title = "Git Browse" })
		end
	end

	if #remotes == 1 then
		return open(remotes[1])
	end

	vim.ui.select(remotes, {
		prompt = "Select remote to browse",
		format_item = function(item)
			return ("%s → %s"):format(item.name, item.url)
		end,
	}, open)
end

return M
