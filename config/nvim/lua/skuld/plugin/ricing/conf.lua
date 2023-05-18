local conf = {}

conf["rose-pine/neovim"] = function()
  -- XXX: this fixes some broken highlights of rose-pine
  -- I have no idea how, let's just pretend this is normal
  vim.cmd.colorscheme("habamax")
end

conf["lukas-reineke/indent-blankline.nvim"] = function()
  require("indent_blankline").setup({
    -- char = '┊',
    -- context_char = '┊',
    show_current_context = true,
    show_current_context_start = true,
  })
end

conf["RRethy/vim-illuminate"] = function()
  require("illuminate").configure({
    providers = { "lsp", "treesitter" },
    delay = 10,
  })
end

conf["karb94/neoscroll.nvim"] = function()
  require("neoscroll").setup({
    -- excluded <C-y> and <C-e> from default `mappings`
    -- to leave it as precise scrolling method
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
    hide_cursor = false,
    easing_function = "quadratic",
  })
end

conf["nvim-ufo"] = function()
  local ufo = require("ufo")
  ufo.setup()

  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  local map = vim.keymap.set
  map("n", "zR", ufo.openAllFolds)
  map("n", "zM", ufo.closeAllFolds)
  map("n", "z[", ufo.goPreviousClosedFold)
  map("n", "z]", ufo.goNextClosedFold)
end

return conf
