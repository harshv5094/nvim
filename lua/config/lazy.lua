require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Prompt before installing missing plugins.
-- lazy.nvim only supports `install.missing = true|false` (auto-install or skip),
-- so intercept `Loader.install_missing` to ask for confirmation at startup.
do
	local Loader = require("lazy.core.loader")
	local orig_install_missing = Loader.install_missing
	Loader.install_missing = function(...)
		local Config = require("lazy.core.config")
		local Plugin = require("lazy.core.plugin")
		local missing = {}
		for _, plugin in pairs(Config.plugins) do
			if not plugin._.installed and not Plugin.has_errors(plugin) then
				missing[#missing + 1] = plugin.name
			end
		end
		if #missing == 0 then
			return false
		end
		-- Non-interactive (CI / --headless): auto-install without prompting.
		if #vim.api.nvim_list_uis() == 0 then
			return orig_install_missing(...)
		end
		table.sort(missing)
		local names = table.concat(missing, "\n- ", 1, math.min(#missing, 10))
		if #missing > 10 then
			names = names .. "\n- ... (and " .. (#missing - 10) .. " more)"
		end
		local choice = vim.fn.confirm(
			"Missing plugins detected (" .. #missing .. "):\n- " .. names .. "\n\nInstall missing plugins?",
			"&Yes\n&No",
			2
		)
		if choice == 1 then
			return orig_install_missing(...)
		end
		-- Declined: prevent lazy from loading any plugin dirs this session.
		-- NOTE: setting `plugin._.cond = false` is NOT enough:
		-- `Loader._load()` checks `not installed` before `cond`, and
		-- `Loader.startup()` still runs every `plugin.init`.
		-- Emptying `Config.plugins` (which is `Config.spec.plugins`) before
		-- `Handler.setup()` / `Loader.startup()` run means: no init, no
		-- start plugins, no handlers, nothing added to rtp.
		for name in pairs(Config.plugins) do
			if name ~= "lazy.nvim" then
				Config.plugins[name] = nil
			end
		end
		vim.g.lazy_install_declined = true
		vim.schedule(function()
			vim.notify("Plugin install declined: skipping plugin load", vim.log.levels.WARN, { title = "lazy.nvim" })
		end)
		return false
	end
end

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- `missing` must stay `true` so our prompt wrapper above gets called.
	install = {
		missing = true,
		colorscheme = { "habamax" },
	},
	-- automatically check for plugin updates
	defaults = {
		lazy = false,
		version = false,
	},
	checker = {
		enabled = true,
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
