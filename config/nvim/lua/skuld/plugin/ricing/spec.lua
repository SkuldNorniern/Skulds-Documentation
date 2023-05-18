local spec = {}

-- primary/alternative colorschemes
-- WieeRd note: solarized is the worst theme to ever exist so I excluded it
spec["rose-pine/neovim"] = { name = "rose-pine", priority = 1000 }
spec["dracula/vim"] = { name = "dracula", lazy = true }
spec["catppuccin/nvim"] = { name = "catppuccin", lazy = true }

-- indentation guide
spec["lukas-reineke/indent-blankline.nvim"] = {}

-- highlight references of the symbol under the cursor
spec["RRethy/vim-illuminate"] = {}

-- smooth scrolling
spec["karb94/neoscroll.nvim"] = {
  keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "z" },
}

-- fancy folding powered by LSP/treesitter
spec["kevinhwang91/nvim-ufo"] = {
  dependencies = "kevinhwang91/promise-async",
}

return spec
