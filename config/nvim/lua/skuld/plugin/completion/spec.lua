local spec = {}

-- completion engine
spec["hrsh7th/nvim-cmp"] = {
  event = "InsertEnter",
  dependencies = {
    -- completion sources
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    -- snippet expander
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
}

-- snippet engine
spec["L3MON4D3/LuaSnip"] = {
  event = "InsertEnter",
  dependencies = {
    -- snippet collection
    "rafamadriz/friendly-snippets",
  },
}

-- generate annotations
spec["danymat/neogen"] = {
  keys = "<Leader>n",
  dependencies = "LuaSnip",
}

-- code ai completion
spec["Exafunction/codeium.vim"] = {}

return spec
