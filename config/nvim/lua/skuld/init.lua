local cfg_root = ...
local vim = vim

local M = {
  options = require(cfg_root .. ".builtin.options"),
  keymaps = require(cfg_root .. ".builtin.keymaps"),
  autocmds = require(cfg_root .. ".builtin.autocmds"),
  commands = require(cfg_root .. ".builtin.commands"),
}

M.load_options = function(options)
  local opt = vim.opt
  for key, value in pairs(options) do
    opt[key] = value
  end
end

M.load_keymaps = function(keymaps)
  local map = vim.keymap.set
  for mode, mappings in pairs(keymaps) do
    for lhs, rhs in pairs(mappings) do
      map(mode, lhs, rhs)
    end
  end
end

M.load_autocmds = function(autocmds)
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup("Skuld", { clear = true })
  for _, opts in ipairs(autocmds) do
    local event = opts[1]
    opts[1] = nil
    opts.group = augroup
    autocmd(event, opts)
  end
end

M.load_commands = function(commands)
  local command = vim.api.nvim_create_user_command
  for name, opts in pairs(commands) do
    local cmd = opts[1]
    opts[1] = nil
    command(name, cmd, opts)
  end
end

M.load_plugins = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  -- bootstrap lazy.nvim
  if not vim.loop.fs_stat(lazypath) then
    local answer = vim.fn.input({
      prompt = "Would you like to setup plugins? [Y/n] ",
    })

    if answer ~= "n" then
      vim.notify(
        "\nWorking on updates 42%\nDo not turn off your Neovim.\nThis will take a while.",
        vim.log.levels.WARN
      )
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim",
        lazypath,
      })
    else
      vim.notify("\nContinuing without plugins.", vim.log.levels.WARN)
      return false
    end
  end

  -- setup lazy.nvim
  vim.opt.runtimepath:prepend(lazypath)
  require("lazy").setup({
    spec = require(cfg_root .. ".plugin"),

    ui = {
      custom_keys = {
        ["<LocalLeader>l"] = false,
        ["<LocalLeader>t"] = false,
      },
    },

    change_detection = {
      enabled = false,
      notify = false,
    },

    performance = {
      rtp = {
        reset = true,
        paths = {},
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
  return true
end

M.setup = function(cfg)
  vim.g.mapleader = cfg.mapleader

  M.load_options(M.options)
  M.load_keymaps(M.keymaps)
  M.load_autocmds(M.autocmds)
  M.load_commands(M.commands)

  if cfg.plugins and M.load_plugins() then
    vim.cmd.colorscheme(cfg.colorscheme.plugin)
  else
    vim.cmd.colorscheme(cfg.colorscheme.builtin)
  end
end

return M
