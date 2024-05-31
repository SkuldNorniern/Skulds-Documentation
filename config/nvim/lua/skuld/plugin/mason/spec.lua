local spec = {}

-- portable package manager for neovim
spec["williamboman/mason.nvim"] = {}

-- setup LSP clients
spec["neovim/nvim-lspconfig"] = {
  dependencies = {
    -- automatically setup language servers installed with mason
    "williamboman/mason-lspconfig.nvim",
    -- Lua: setup for Neovim config/plugin developement
    "folke/neodev.nvim",
    -- Rust: bunch of extra features
    "simrat39/rust-tools.nvim",
    -- LTeX: enable extra features from LanguageTools
    "barreiroleo/ltex_extra.nvim",
  },
}

-- setup linters and formatters
spec["jose-elias-alvarez/null-ls.nvim"] = {
  dependencies = {
    -- automatically setup linters/formatters installed with mason
    "jay-babu/mason-null-ls.nvim",
  },
}

-- setup DAP clients
spec["mfussenegger/nvim-dap"] = {
  keys = { "<Leader>d" },
  dependencies = {
    -- automatically setup debuggers installed with mason
    "jay-babu/mason-nvim-dap.nvim",
    -- provides debugging session UI
    "rcarriga/nvim-dap-ui",
    -- show variable state in a virtual text
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio"
  },
}

return spec
