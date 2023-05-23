local conf = {}

conf["williamboman/mason.nvim"] = function()
  require("mason").setup({
    install_root_dir = vim.fn.stdpath("data") .. "/mason",
    PATH = "prepend", -- prepend | append | skip
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
    ui = {
      check_outdated_packages_on_open = true,
      border = "none",
      -- WieeRd note: this layout may not be suitable for W I D E monitor
      width = 0.8,
      height = 0.9,
      icons = {
        -- ✓ ➜ ✗ ◍
        package_installed = "◍",
        package_pending = "➜",
        package_uninstalled = "◍",
      },
    },
  })
end

conf["neovim/nvim-lspconfig"] = function()
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")
  local wk = require("which-key")

  -- global default
  local global_config = {
    capabilities = {
      textDocument = {
        -- for `cmp-nvim-lsp`
        completion = {
          completionItem = {
            commitCharactersSupport = true,
            deprecatedSupport = true,
            insertReplaceSupport = true,
            insertTextModeSupport = {
              valueSet = { 1, 2 },
            },
            labelDetailsSupport = true,
            preselectSupport = true,
            resolveSupport = {
              properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
              },
            },
            snippetSupport = true,
            tagSupport = {
              valueSet = { 1 },
            },
          },
          completionList = {
            itemDefaults = {
              "commitCharacters",
              "editRange",
              "insertTextFormat",
              "insertTextMode",
              "data",
            },
          },
          contextSupport = true,
          dynamicRegistration = false,
          insertTextMode = 1,
        },
        -- for `nvim-ufo`
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(client, bufnr)
      local function bind(func, opts)
        return function()
          func(opts)
        end
      end

      -- navigate diagnostics
      local dg = vim.diagnostic

      wk.register({
        ["]"] = {
          name = "+next",
          d = { dg.goto_next, "diagnostic" },
          D = { bind(dg.goto_next, { severity = dg.severity.WARN }), "warning" },
        },
        ["["] = {
          name = "+prev",
          d = { dg.goto_prev, "diagnostic" },
          D = { bind(dg.goto_prev, { severity = dg.severity.WARN }), "warning" },
        },

        g = {
          name = "+goto",
          d = { vim.lsp.buf.definition, "definition" },
          D = { vim.lsp.buf.type_definition, "type definition" },
        },

        ["<Leader>l"] = {
          name = "+LSP",
          r = { vim.lsp.buf.rename, "rename" },
          a = { vim.lsp.buf.code_action, "code action" },
        },

        K = { vim.lsp.buf.hover, "LSP docs" },
      }, { buffer = bufnr })

      -- NOTE: lsp formatting keymaps -> null-ls.nvim
    end,
    handlers = {
      ["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers["textDocument/hover"],
        { border = "solid" }
      ),
    },
  }

  -- set global config
  for k, v in pairs(global_config) do
    ---@diagnostic disable-next-line: assign-type-mismatch
    lspconfig.util.default_config[k] = v
  end

  -- setup each servers
  mason_lspconfig.setup()
  mason_lspconfig.setup_handlers({
    function(server)
      lspconfig[server].setup({})
    end,
    ["lua_ls"] = function()
      require("neodev").setup({
        library = {
          enabled = true,
          runtime = true,
          types = true,
          plugins = true,
        },
        setup_jsonls = true,
        lspconfig = true,
      })
      lspconfig["lua_ls"].setup({
        settings = {
          Lua = {
            completion = {
              showWord = "Disable",
            },
            diagnostics = {
              disable = { "redefined-local" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })
    end,
    ["rust_analyzer"] = function()
      require("rust-tools").setup({
        server = {
          on_attach = lspconfig.util.default_config.on_attach,
        },
      })
    end,
    ["ltex"] = function()
      lspconfig["ltex"].setup({
        filetypes = {
          "bib",
          -- "gitcommit",
          "markdown",
          "org",
          "plaintex",
          "rst",
          "rnoweb",
          "tex",
          "text",
        },
        on_attach = function(client, bufnr)
          require("ltex_extra").setup({
            load_langs = { "en-US" },
            init_check = true, -- load dictionaries on startup
            path = vim.fn.stdpath("data") .. "/ltex", -- where to save dictionaries
            log_level = "error",
          })
          lspconfig.util.default_config.on_attach(client, bufnr)
        end,
      })
    end,
  })

  -- diagnostic appearance
  vim.diagnostic.config({
    signs = false,
    underline = true,
    float = {
      border = "solid",
      source = false,
    },
    virtual_text = {
      severity = { min = vim.diagnostic.severity.WARN },
      prefix = " ●",
      format = function(diagnostic)
        local icon = { "E", "W", "I", "H" }
        -- truncate multi-line diagnostics
        local message = string.match(diagnostic.message, "([^\n]*)\n?")
        return string.format("%s: %s ", icon[diagnostic.severity], message)
      end,
    },
    update_in_insert = false,
    severity_sort = true,
  })
end

conf["jose-elias-alvarez/null-ls.nvim"] = function()
  local mason_null_ls = require("mason-null-ls")
  local null_ls = require("null-ls")

  -- setup linters & formatters installed with mason
  mason_null_ls.setup({
    ensure_installed = {},
    automatic_installation = false,
    automatic_setup = true,
    handlers = {},
  })

  -- sources that are not from mason
  null_ls.setup({
    sources = {
      null_ls.builtins.hover.dictionary,
    },
  })

  -- `gq{motion}` to format range
  -- I had to do this manually since `vim.lsp.formatexpr`
  -- does not provide a way to filter clients
  vim.keymap.set("o", "gq", function()
    local start_lnum = vim.v.lnum
    local end_lnum = start_lnum + vim.v.count - 1

    vim.lsp.buf.format({
      async = false,
      name = "null-ls",
      range = {
        ["start"] = { start_lnum, 0 },
        ["end"] = { end_lnum, 0 },
      },
    })
  end, { expr = true, desc = "format range" })

  -- `gQ` to format entire buffer
  vim.keymap.set("n", "gQ", function()
    vim.lsp.buf.format({
      async = false,
      name = "null-ls",
    })
  end, { desc = "format buffer" })
end

conf["mfussenegger/nvim-dap"] = function()
  local vim = vim
  local mason_nvim_dap = require("mason-nvim-dap")
  local dap = require("dap")
  local dap_ui = require("dapui")
  local dap_vtext = require("nvim-dap-virtual-text")

  -- setup DAP clients installed with mason
  mason_nvim_dap.setup({
    ensure_installed = {},
    automatic_installation = false,
    automatic_setup = true,
    handlers = {},
  })

  dap_ui.setup({
    controls = { enabled = true },
    icons = {
      collapsed = "▶",
      current_frame = "▶",
      expanded = "▼",
    },
    layouts = {
      {
        elements = {
          { id = "stacks", size = 0.25 },
          { id = "breakpoints", size = 0.25 },
          { id = "scopes", size = 0.25 },
          { id = "watches", size = 0.25 },
        },
        position = "left",
        size = 40,
      },
      {
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
        },
        position = "bottom",
        size = 10,
      },
    },
  })

  dap_vtext.setup({
    ---@diagnostic disable-next-line: unused-local
    display_callback = function(variable, _buf, _stackframe, _node)
      return (" ◍ %s = %s "):format(variable.name, variable.value)
    end,
  })

  -- automatically open/close dapui
  dap.listeners.after["event_initialized"]["dapui"] = dap_ui.open
  dap.listeners.before["event_terminated"]["dapui"] = dap_ui.close
  dap.listeners.before["event_exited"]["dapui"] = dap_ui.close

  local signs = {
    --    󰁕
    DapBreakpoint = { text = "○", texthl = "DiagnosticSignError" },
    DapBreakpointCondition = { text = "", texthl = "DiagnosticSignWarn" },
    DapLogPoint = { text = "", texthl = "DiagnosticSignOk" },
    DapStopped = { text = "●", texthl = "DiagnosticSignError" },
    DapBreakpointRejected = { text = "", texthl = "DiagnosticError" },
  }

  local sign_define = vim.fn.sign_define
  for name, attr in pairs(signs) do
    sign_define(name, attr)
  end

  ---jump to the window of specified dapui element
  ---@param element string filetype of the element
  local function jump_to_element(element)
    local visible_wins = vim.api.nvim_tabpage_list_wins(0)

    for _, win in ipairs(visible_wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == element then
        vim.api.nvim_set_current_win(win)
        return
      end
    end

    vim.notify(("element '%s' not found"):format(element), vim.log.levels.WARN)
  end

  local function bind(func, ...)
    local args = ...
    return function()
      return func(args)
    end
  end

  require("which-key").register({
    ["<Leader>d"] = {
      name = "+DAP",
      -- start/stop debugging
      ["]"] = { dap.continue, "continue" },
      ["["] = { dap.reverse_continue, "reverse continue" },
      [" "] = { dap.pause, "pause" },
      ["r"] = { dap.restart, "restart" },
      ["t"] = { dap.terminate, "terminate" },

      -- breakpoints
      ["."] = { dap.toggle_breakpoint, "toggle breakpoint" },
      ["c"] = {
        function()
          vim.ui.input({ prompt = "Breakpoint Condition: " }, function(input)
            return input and dap.set_breakpoint(input, nil, nil)
          end)
        end,
        "conditional breakpoint",
      },
      ["h"] = {
        function()
          vim.ui.input({ prompt = "Breakpoint Hit Condition: " }, function(cond)
            return cond and dap.set_breakpoint(nil, cond, nil)
          end)
        end,
        "hit breakpoint",
      },
      ["l"] = {
        function()
          vim.ui.input({ prompt = "Log Point Message: " }, function(msg)
            return msg and dap.set_breakpoint(nil, nil, msg)
          end)
        end,
        "log point"
      },
      ["x"] = { dap.clear_breakpoints, "clear breakpoints" },

      -- UI
      ["u"] = { dap_ui.toggle, "toggle UI" },
      ["w"] = { bind(jump_to_element, "dapui_watches"), "watches panel" },
      ["v"] = { bind(jump_to_element, "dapui_scopes"), "scopes panel" },
      ["b"] = { bind(jump_to_element, "dapui_breakpoints"), "breakpoints panel" },
      ["s"] = { bind(jump_to_element, "dapui_stacks"), "stacks panel" },
      -- ["?"] = { bind(jump_to_element, "dapui_console"), "console panel" },
      -- ["?"] = { bind(jump_to_element, "dap-repl), "REPL panel },
    },

    -- step
    ["<Right>"] = { dap.step_over, "DAP step over" },
    ["<Left>"] = { dap.step_back, "DAP step back" },
    ["<Up>"] = { dap.step_out, "DAP step out" },
    ["<Down>"] = { dap.step_into, "DAP step into" },
  })
end

return conf
