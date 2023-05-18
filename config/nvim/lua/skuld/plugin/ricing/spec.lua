local spec = {}

-- favorite colorschemes. `priority = 1000` -> current theme
-- WieeRd note: solarized is the worst theme to ever exist so I excluded it
spec["rose-pine/neovim"] = { name = "rose-pine", priority = 1000 }
spec["dracula/vim"] = { name = "dracula", lazy = true }
spec["catppuccin/nvim"] = { name = "catppuccin", lazy = true } -- try catppuccin instead

-- indentation guide
spec["lukas-reineke/indent-blankline.nvim"] = {}

-- highlight references of the symbol under the cursor
spec["RRethy/vim-illuminate"] = {}

-- smooth scrolling
spec["karb94/neoscroll.nvim"] = {
  keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "z" },
}

-- literally scrollbar what do you expect
spec["petertriho/nvim-scrollbar"] = {}

-- fancy folding
spec["kevinhwang91/nvim-ufo"] = {
  dependencies = "kevinhwang91/promise-async",
}

-- fancy notification
spec["rcarriga/nvim-notify"] = {}

-- fancy statusline
spec["nvim-lualine/lualine.nvim"] = {}

-- fancy bufferline
spec["akinsho/bufferline.nvim"] = {}

-- fancy everything (whoa!)
spec["folke/noice.nvim"] = {}

return spec
