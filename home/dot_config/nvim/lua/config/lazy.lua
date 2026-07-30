-- =============================================================================
-- lazy.nvim Package Manager Setup
--
-- Bootstraps lazy.nvim if not already installed, then configures it with
-- the LazyVim starter distribution as the base spec.
-- =============================================================================

-- Bootstrap lazy.nvim (auto-install on first launch)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath,
  })
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

-- Validate Neovim version
require("lazy").setup({
  spec = {
    -- Import LazyVim and its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    },
    -- Import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded.
    -- Your custom plugins will load during startup.
    -- If you know what you're doing, set this to `true` to lazy-load all plugins.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot of plugins
    -- that support versioning have outdated releases.
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- don't notify on update availability
  },
  performance = {
    rtp = {
      -- Disable some rtp plugins to speed up startup
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
