local M = {}
local vim = vim

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
  local augroup = vim.api.nvim_create_augroup("Skuld")

  for _, opts in ipairs(autocmds) do
    local event = opts[1]
    opts.group = augroup
    autocmd(event, opts)
  end
end

M.load_commands = function(commands)
  local command = vim.api.nvim_create_user_command
  for name, opts in pairs(commands) do
    local cmd = opts[1]
    command(name, cmd, opts)
  end
end

M.setup = function(cfg)
  vim.g.mapleader = cfg.mapleader

  local options = require("skuld.builtin.options")
  local keymaps = require("skuld.builtin.keymaps")
  local autocmds = require("skuld.builtin.autocmds")
  local commands = require("skuld.builtin.commands")

  M.load_options(options)
  M.load_keymaps(keymaps)
  M.load_autocmds(autocmds)
  M.load_commands(commands)
end

return M
