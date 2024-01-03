local spec = {}

-- auto insert/remove closing pair
spec["windwp/nvim-autopairs"] = {
  event = "InsertEnter",
}

-- manipulate surrounding pair
spec["kylechui/nvim-surround"] = {
  keys = { "cs", "ds", "ys", { "S", mode = "v" } },
}

-- highlight and jump between matching pairs
spec["andymass/vim-matchup"] = {}

-- more around/inside text objects
spec["echasnovski/mini.ai"] = {}

-- comment out parts of code
spec["numToStr/Comment.nvim"] = {
  keys = {
    { "gc", mode = { "n", "v" } },
    { "gb", mode = { "n", "v" } },
  },
  dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
}

-- split/join multi-line statement
spec["Wansmer/treesj"] = {
  keys = {
    { "gJ", "<Cmd>TSJJoin<CR>" },
    { "gS", "<Cmd>TSJSplit<CR>" },
  },
}

-- live tips for efficient editing workflow
spec["m4xshen/hardtime.nvim"] = {}

return spec
