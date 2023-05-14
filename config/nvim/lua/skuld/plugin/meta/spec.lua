local spec = {}

-- lazy.nvim can manage itself
spec["folke/lazy.nvim"] = {}

-- library of useful Lua functions
spec["nvim-lua/plenary.nvim"] = {}

-- treesitter integration
spec["nvim-treesitter/nvim-treesitter"] = {
  build = ":TSUpdate",
  dependencies = {
    -- indenting
    "yioneko/nvim-yati",
    -- motions & text objects
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- smart text objects
    "RRethy/nvim-treesitter-textsubjects",
    -- auto insert matching keywords (e.g. function/end in Lua)
    "RRethy/nvim-treesitter-endwise",
    -- correctly comment out embedded langauges
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    -- highlight and jump between matching keywords
    "andymass/vim-matchup",
  },
}

-- provide filetype icons
spec["kyazdani42/nvim-web-devicons"] = {}

-- provide LSP symbol icons
spec["onsails/lspkind.nvim"] = {}

return spec
