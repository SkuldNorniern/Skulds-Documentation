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

conf["petertriho/nvim-scrollbar"] = function()
  require("scrollbar").setup()
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

conf["rcarriga/nvim-notify"] = function()
  vim.notify = require("notify")
end

conf["nvim-lualine/lualine.nvim"] = function()
  local colors = {
    blue = "#80a0ff",
    cyan = "#79dac8",
    black = "#080808",
    white = "#c6c6c6",
    red = "#ff5189",
    violet = "#d183e8",
    grey = "#303030",
  }

  local bubbles_theme = {
    normal = {
      a = { fg = colors.black, bg = colors.violet },
      b = { fg = colors.white, bg = colors.grey },
      c = { fg = colors.black, bg = colors.black },
    },

    insert = { a = { fg = colors.black, bg = colors.blue } },
    visual = { a = { fg = colors.black, bg = colors.cyan } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
      a = { fg = colors.white, bg = colors.black },
      b = { fg = colors.white, bg = colors.black },
      c = { fg = colors.black, bg = colors.black },
    },
  }

  require("lualine").setup({
    options = {
      theme = bubbles_theme,
      component_separators = "|",
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = {
        { "mode", separator = { left = "" }, right_padding = 2 },
      },
      lualine_b = { "filename", "branch" },
      lualine_c = { "fileformat" },
      lualine_x = {},
      lualine_y = { "filetype", "progress" },
      lualine_z = {
        { "location", separator = { right = "" }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "location" },
    },
    tabline = {},
    extensions = {},
  })
end

conf["akinsho/bufferline.nvim"] = function()
  require("bufferline").setup()
end

conf["folke/noice.nvim"] = function()
  require("noice").setup()
end

return conf
