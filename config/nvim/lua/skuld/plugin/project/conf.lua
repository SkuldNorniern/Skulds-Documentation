local conf = {}

conf["notjedi/nvim-rooter.lua"] = function()
  require("nvim-rooter").setup()
end

conf["tpope/vim-fugitive"] = function()
  local vim = vim
  local wk = require("which-key")

  wk.register({
    ["<Leader>g"] = {
      name = "+git",
      i = { "<Cmd>tab G<CR>", "index" },
      r = { "<Cmd>Git restore %<CR>", "restore buffer" },
      s = { "<Cmd>Git stage %<CR>", "stage buffer" },
      u = { "<Cmd>Git reset -q %<CR>", "unstage buffer" },
    },
  })

  -- trigger "User InGitRepo" event upon entering a Git repository
  -- can be used to lazy load other Git related plugins
  -- `nvim-rooter.lua` allows us to use "DirChanged" instead of "BufRead"
  vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    callback = function()
      -- local gitdir = vim.loop.cwd() .. "/.git"
      -- if vim.loop.fs_stat(gitdir) then
      local cmd = "git rev-parse --is-inside-work-tree"
      if vim.fn.system(cmd) == "true\n" then
        vim.api.nvim_exec_autocmds("User", { pattern = "InGitRepo" })
        return true -- remove this autocmd after loading other plugins
      end
    end,
    group = vim.api.nvim_create_augroup("DetectGitRepo", {}),
  })
end

conf["lewis6991/gitsigns.nvim"] = function()
  local gs = require("gitsigns")
  local wk = require("which-key")

  gs.setup({
    -- diff indicator
    signcolumn = true, -- :Gitsigns toggle_signs
    numhl = false, -- :Gitsigns toggle_numhl
    linehl = false, -- :Gitsigns toggle_linehl
    word_diff = false, -- :Gitsigns toggle_word_diff

    -- show blame result in virtual text
    current_line_blame = false, -- :Gitsigns toggle_current_line_blame
    current_line_blame_opts = { delay = 100 },
    current_line_blame_formatter = " <author> (<author_time:%R>) <summary> ",

    -- options passed to `nvim_open_win()`
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 1,
      col = 1,
    },
  })

  local function next_hunk()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end

  local function prev_hunk()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return "<Ignore>"
  end

  local function hunk_or_blame()
    local acts = gs.get_actions()
    if acts ~= nil then
      local func = acts.preview_hunk or acts.blame_line
      if func ~= nil then
        return func({ full = true })
      end
    end
  end

  wk.register({
    ["<Leader>g"] = {
      p = { hunk_or_blame, "preview hunk or blame" },

      -- toggle diff highlight
      ["h"] = { gs.toggle_linehl, "toggle highlight" },
      ["+"] = { gs.toggle_signs, "toggle signs" },
      ["0"] = { gs.toggle_numhl, "toggle numhl" },
      ["-"] = { gs.toggle_deleted, "toggle deleted" },

      -- live blame current line
      b = { gs.toggle_current_line_blame, "toggle live blame" },
    },
  })

  wk.register({
    ["]"] = { c = { next_hunk, "next hunk", expr = true } },
    ["["] = { c = { prev_hunk, "prev hunk", expr = true } },
    ["gh"] = {
      name = "+git hunk",
      r = { ":Gitsigns reset_hunk<CR>", "restore hunk" },
      s = { ":Gitsigns stage_hunk<CR>", "stage hunk" },
      u = { ":Gitsigns undo_stage_hunk<CR>", "unstage hunk" },
    },
  }, { mode = { "n", "v" } })

  wk.register({
    ih = { ":Gitsigns select_hunk<CR>", "inner hunk" },
    ah = { ":Gitsigns select_hunk<CR>", "around hunk" },
  }, { mode = { "o", "v" } })
end

conf["sindrets/diffview.nvim"] = function()
  local dv = require("diffview")
  local wk = require("which-key")

  dv.setup({
    enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
    file_panel = {
      -- :h diffview-config-win_config
      win_config = {
        position = "left",
        width = 35,
        win_opts = { winhl = "Normal:NormalFloat" },
      },
    },
    file_history_panel = {
      win_config = {
        position = "bottom",
        height = 16,
        win_opts = { winhl = "Normal:NormalFloat" },
      },
    },
    commit_log_panel = {
      win_config = {
        win_opts = { winhl = "Normal:NormalFloat" },
      },
    },
    -- :h diffview-config-hooks
    hooks = {
      diff_buf_read = function(bufnr)
        vim.wo.relativenumber = false
        vim.wo.cursorline = true
        vim.wo.foldcolumn = "0"
      end,
    },
  })

  wk.register({
    ["<Leader>g"] = {
      d = { ":DiffviewOpen -uno<CR>", "view diff (tracked)" },
      D = { ":DiffviewOpen<CR>", "view diff (all)" },

      l = { ":DiffviewFileHistory %", "commit log (file)" },
      L = { ":DiffviewFileHistory<CR>", "commit log (project)" },
    },
  })

  wk.register({
    ["<Leader>gl"] = { ":DiffviewFileHistory<CR>", "commit log (selected)" },
  }, { mode = "v" })
end

conf["rmagatti/auto-session"] = function()
  require("auto-session").setup({
    log_level = "error",
    -- restore last session only when opening Neovim in the home directory
    -- which usually right after launching the terminal or GUI client
    auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
    auto_session_enabled = true,
    auto_session_create_enabled = false,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    session_lens = {
      shorten_path = true,
      load_on_setup = false, -- will be loaded in the telescope config
    },
  })
end

return conf
