local spec = {}

-- automatically cd to project root
spec["notjedi/nvim-rooter.lua"] = {}

-- `$ git` wrapped as `:G`, interactable git index
spec["tpope/vim-fugitive"] = {}

-- preview and manipulate hunks
spec["lewis6991/gitsigns.nvim"] = {
  event = "User InGitRepo",
}

-- nice viewer for `$ git diff` and `$ git log`
spec["sindrets/diffview.nvim"] = {
  event = "User InGitRepo",
}

-- auto save & load sessions
spec["rmagatti/auto-session"] = {
  event = "VimEnter",
}

return spec
