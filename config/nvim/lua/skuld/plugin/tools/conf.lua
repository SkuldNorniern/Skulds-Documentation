local conf = {}

conf["nvim-telescope/telescope.nvim"] = function()
  local telescope = require("telescope")
  local builtin = require("telescope.builtin")
  local themes = require("telescope.themes")

  local wk = require("which-key")

  -- configuration
  telescope.setup({
    -- global default
    defaults = {
      -- search prompt appearance
      prompt_prefix = "  ",
      selection_caret = " ",
      entry_prefix = " ",
      sorting_strategy = "descending",

      -- layout
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "bottom",
          preview_cutoff = 120,

          -- WieeRd note: below are my prefered layout;
          -- but it may not look pretty on your W I D E monitor
          -- uncomment, try it, and see for yourself!

          -- width = 0.7,
          -- height = 0.8,
          -- preview_width = 0.6,
          -- results_width = 0.8,
        },
      },
    },
  })

  -- load extensions
  telescope.load_extension("fzf")

  local auto_session = require("auto-session")
  auto_session.setup_session_lens()
  telescope.load_extension("session-lens")

  -- define keymaps
  local function bind(func, opts)
    return function()
      func(opts)
    end
  end

  local diagnostics = builtin.diagnostics
  local session_lens = require("auto-session.session-lens")

  wk.register({
    ["<C-p>"] = {
      bind(builtin.find_files, themes.get_dropdown({ previewer = false })),
      "quick switch file",
    },

    ["<Leader>f"] = {
      name = "+find",

      [" "] = { builtin.builtin, "pickers" },
      ["."] = { builtin.resume, "resume" },

      ["/"] = { builtin.current_buffer_fuzzy_find, "string" },
      ["?"] = { builtin.live_grep, "live grep" },

      f = { builtin.find_files, "files" },
      b = { builtin.buffers, "buffers" },

      r = { builtin.lsp_references, "references" },
      s = { builtin.lsp_document_symbols, "symbols" },

      d = { bind(diagnostics, { bufnr = 0 }), "diagnostics (buffer)" },
      D = { bind(diagnostics, { root_dir = true }), "diagnostics (project)" },

      h = { builtin.help_tags, "help tags" },
      m = { builtin.man_pages, "man page" },

      p = { session_lens.search_session, "sessions" },
    },
  })
end

conf["stevearc/aerial.nvim"] = function()
  local aerial = require("aerial")

  aerial.setup({
    backends = { "treesitter", "lsp", "markdown", "man" },
    layout = {
      max_width = { 30, 0.2 },
      min_width = 24,

      -- key-value pairs of window-local options for aerial window (e.g. winhl)
      win_opts = { winhl = "Normal:NormalFloat" },

      -- prefer_right, prefer_left, right, left, float
      default_direction = "left",

      -- edge   - open aerial at the far right/left of the editor
      -- window - open aerial to the right/left of the current window
      placement = "window",

      -- Preserve window size equality with (:help CTRL-W_=)
      preserve_equality = false,
    },

    -- Determines how the aerial window decides which buffer to display symbols for
    -- window - aerial window will display symbols for the buffer in the window from which it was opened
    -- global - aerial window will display symbols for the current window
    attach_mode = "window",

    -- List of enum values that configure when to auto-close the aerial window
    -- unfocus, switch_buffer, unsupported
    close_automatic_events = {},

    -- Determines line highlighting mode when multiple splits are visible.
    -- split_width, full_width, last, none
    highlight_mode = "full_width",

    -- Highlight the closest symbol if the cursor is not exactly on one.
    highlight_closest = true,

    -- Highlight the symbol in the source buffer when cursor is in the aerial win
    highlight_on_hover = true,

    -- When jumping to a symbol, highlight the line for this many ms.
    -- Set to false to disable
    highlight_on_jump = false,

    -- Run this command after jumping to a symbol (false will disable)
    post_jump_cmd = "normal! zz",

    -- When true, aerial will automatically close after jumping to a symbol
    close_on_select = true,

    -- Show box drawing characters for the tree hierarchy
    show_guides = true,
  })

  vim.keymap.set("n", "<Leader>a", aerial.toggle, { desc = "aerial" })
end

conf["nvim-neo-tree/neo-tree.nvim"] = function()
  require("neo-tree").setup()
  vim.keymap.set("n", "<Leader>n", "<Cmd>Neotree<CR>", { desc = "file tree" })
end

conf["akinsho/toggleterm.nvim"] = function()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return math.max(math.min(16, vim.o.lines * 0.25), 5)
      elseif term.direction == "vertical" then
        return math.min(80, math.floor(vim.o.columns * 0.5))
      end
    end,

    open_mapping = "<S-Tab>",
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,

    persist_size = false,
    persist_mode = false,

    on_open = function(term)
      if term.direction == "float" then
        vim.wo.winhl = ""
      end
    end,

    direction = "float",
    close_on_exit = true,
    auto_scroll = true,

    float_opts = {
      border = "solid",
      width = function(_)
        return math.min(120, vim.o.columns - 6)
      end,
      height = function(_)
        return math.min(35, math.floor(vim.o.lines * 0.7))
      end,
      winblend = nil,
    },
  })
end

conf["willothy/flatten.nvim"] = function()
  require("flatten").setup()
end

conf["ellisonleao/glow.nvim"] = function()
  require("glow").setup()
end

conf["samodostal/image.nvim"] = function()
  require("image").setup({
    render = {
      min_padding = 5,
      show_label = true,
      use_dither = true,
      foreground_color = true,
      background_color = true,
    },
    events = {
      update_on_nvim_resize = true,
    },
  })
end

return conf
