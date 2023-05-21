local conf = {}

conf["notjedi/nvim-rooter.lua"] = function()
  require("nvim-rooter").setup()
end

conf["tpope/vim-fugitive"] = function()
  local vim = vim
  local map = vim.keymap.set

  map("n", "<Leader>gi", "<Cmd>tab G<CR>")
  map("n", "<Leader>gr", "<Cmd>Git restore %<CR>")
  map("n", "<Leader>gs", "<Cmd>Git stage %<CR>")
  map("n", "<Leader>gu", "<Cmd>Git reset -q %<CR>")

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

  local function hunk_or_blame(...)
    local acts = gs.get_actions()
    if acts ~= nil then
      local func = acts.preview_hunk or acts.blame_line
      if func ~= nil then
        return func(...)
      end
    end
  end

  local map = vim.keymap.set

  -- hunk motion
  map({ "n", "v" }, "]c", next_hunk, { expr = true })
  map({ "n", "v" }, "[c", prev_hunk, { expr = true })

  -- hunk text object
  map({ "o", "v" }, "ih", gs.select_hunk)
  map({ "o", "v" }, "ah", gs.select_hunk)

  -- hunk actions
  map({ "n", "v" }, "ghr", ":Gitsigns reset_hunk<CR>")
  map({ "n", "v" }, "ghs", ":Gitsigns stage_hunk<CR>")
  map({ "n", "v" }, "ghu", ":Gitsigns undo_stage_hunk<CR>")

  -- preview hunk or blame result of current line
  map("n", "<Leader>gp", function()
    hunk_or_blame({ full = true })
  end)

  -- toggle diff highlight
  map("n", "<Leader>gh", gs.toggle_linehl)
  map("n", "<Leader>g+", gs.toggle_signs)
  map("n", "<Leader>g0", gs.toggle_numhl)
  map("n", "<Leader>g-", gs.toggle_deleted)

  -- live blame current line
  map("n", "<Leader>gb", gs.toggle_current_line_blame)
end

conf["sindrets/diffview.nvim"] = function()
  local dv = require("diffview")

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

  local map = vim.keymap.set

  -- git diff
  map("n", "<Leader>gd", "<Cmd>DiffviewOpen -uno<CR>") -- only tracked files
  map("n", "<Leader>gD", "<Cmd>DiffviewOpen<CR>") -- include untracked files

  -- git log / blame
  map("n", "<Leader>gl", "<Cmd>DiffviewFileHistory %<CR>") -- current file
  map("x", "<Leader>gl", "<Cmd>'<,'>DiffviewFileHistory<CR>") -- selected range
  map("n", "<Leader>gL", "<Cmd>DiffviewFileHistory<CR>") -- project wide
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
