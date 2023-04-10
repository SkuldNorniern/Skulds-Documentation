local vim = vim
local augroup = vim.api.nvim_create_augroup("CustomAutocmds", { clear = true })

local function autocmd(event, opts)
  opts.group = opts.group or augroup
  return vim.api.nvim_create_autocmd(event, opts)
end

local doautocmd = vim.api.nvim_exec_autocmds

local function nk_ft_nukleus()
  if vim.fn.expand("%:e") == "nk" then
    vim.bo.filetype = "nukleus"
  end
  if vim.bo.filetype == "nukleus" then
    vim.cmd("set syntax=rust")
  end
end

autocmd("BufReadPre",{callback = nk_ft_nukleus})
