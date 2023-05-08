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

M.setup = function(cfg)
  vim.g.mapleader = cfg.mapleader

  M.load_options(M.options)
  M.load_keymaps(M.keymaps)
  M.load_autocmds(M.autocmds)
  M.load_commands(M.commands)

  if cfg.plugins then
    require(cfg_root .. ".plugin")
    vim.cmd.colorscheme(cfg.colorscheme.plugin)
  else
    vim.cmd.colorscheme(cfg.colorscheme.builtin)
  end
end

return M
