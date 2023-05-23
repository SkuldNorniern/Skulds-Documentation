local spec = {}

-- find stuffs
spec["nvim-telescope/telescope.nvim"] = {
  branch = "0.1.x",
  cmd = "Telescope",
  keys = { "<C-p>", "<Leader>f" },
  dependencies = {
    -- `$ fzf` as a fuzzy sort engine
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    -- search created sessions with session-lens
    { "rmagatti/auto-session" },
  },
}

-- file tree sidebar
spec["nvim-neo-tree/neo-tree.nvim"] = {
  keys = "<Leader>n",
}

-- code outline (view tree of symbols)
spec["stevearc/aerial.nvim"] = {
  keys = "<Leader>a",
}

-- manage terminal windows
spec["akinsho/toggleterm.nvim"] = {
  keys = "<S-Tab>",
}

-- avoid nesting nvim inside embedded terminal
spec["willothy/flatten.nvim"] = {}

-- markdown preview with `$ glow`
spec["ellisonleao/glow.nvim"] = {
  cmd = "Glow",
}

return spec
