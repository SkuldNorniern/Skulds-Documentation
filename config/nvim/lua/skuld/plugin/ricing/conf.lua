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

conf["giusgad/pets.nvim"] = function()
  require("pets").setup({
    row = 1, -- the row (height) to display the pet at (higher row means the pet is lower on the screen), must be 1<=row<=10
    col = 0, -- the column to display the pet at (set to high number to have it stay still on the right side)
    speed_multiplier = 1, -- you can make your pet move faster/slower. If slower the animation will have lower fps.
    default_pet = "dog", -- the pet to use for the PetNew command
    default_style = "brown", -- the style of the pet to use for the PetNew command
    random = true, -- whether to use a random pet for the PetNew command, overrides default_pet and default_style
    death_animation = true, -- animate the pet's death, set to false to feel less guilt -- currently no animations are available
    popup = { -- popup options, try changing these if you see a rectangle around the pets
      width = "30%", -- can be a string with percentage like "45%" or a number of columns like 45
      winblend = 100, -- winblend value - see :h 'winblend' - only used if avoid_statusline is false
      hl = { Normal = "Normal" }, -- hl is only set if avoid_statusline is true, you can put any hl group instead of "Normal"
      avoid_statusline = false, -- if winblend is 100 then the popup is invisible and covers the statusline, if that
      -- doesn't work for you then set this to true and the popup will use hl and will be spawned above the statusline (hopefully)
    }
  })
end

return conf
