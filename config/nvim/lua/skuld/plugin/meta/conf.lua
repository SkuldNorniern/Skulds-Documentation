local conf = {}

conf["nvim-treesitter/nvim-treesitter"] = function()
  require("nvim-treesitter.configs").setup({
    -- install these on startup
    ensure_installed = {
      "bash",
      "comment",
      "git_rebase",
      "gitcommit",
    },
    -- install missing parsers on demand
    auto_install = true,

    -- semantic code highlighting
    highlight = {
      enable = true,
      disable = function(lang, buf)
        -- fixes broken highlights inside cmdline window (#3961)
        if lang == "vim" then
          local bufname = vim.api.nvim_buf_get_name(buf)
          return string.match(bufname, "%[Command Line%]")
        end
      end,
      additional_vim_regex_highlighting = false,
    },

    -- builtin indent module have some flaws
    indent = { enable = false },
    -- using yati instead while it gets fixed
    yati = { enable = true },

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
        },
        include_surrounding_whitespace = function(args)
          return args.query_string:match("outer")
        end,
      },

      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]]"] = "@class.outer",
          ["]m"] = "@function.outer",
        },
        goto_next_end = {
          ["]["] = "@class.outer",
          ["]M"] = "@function.outer",
        },
        goto_previous_start = {
          ["[["] = "@class.outer",
          ["[m"] = "@function.outer",
        },
        goto_previous_end = {
          ["[]"] = "@class.outer",
          ["[M"] = "@function.outer",
        },
      },

      swap = {
        enable = true,
        swap_next = {
          ["],"] = "@parameter.inner",
        },
        swap_previous = {
          ["[,"] = "@parameter.inner",
        },
      },
    },

    textsubjects = {
      enable = true,
      prev_selection = "<BS>",
      keymaps = {
        ["<CR>"] = "textsubjects-smart",
        ["a<CR>"] = "textsubjects-container-outer",
        ["i<CR>"] = "textsubjects-container-inner",
      },
    },

    endwise = { enable = true },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },

    matchup = {
      enable = true,
      disable_virtual_text = true,
      include_match_words = true,
    },
  })
end

conf["onsails/lspkind.nvim"] = function()
  require("lspkind").init({
    symbol_map = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "",
      Constructor = "",
      Field = "󰜢",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "",
    },
  })
end

return conf
