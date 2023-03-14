call plug#begin('~/.vim/plugged')
" File Tree Visual
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

" Tools
" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
"Plug 'skywind3000/vim-keysound'
Plug 'psliwka/vim-smoothie'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'rsaraf/vim-advanced-lint'
Plug 'lewis6991/gitsigns.nvim'
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'ellisonleao/glow.nvim'

" Terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

" Theme
Plug 'dracula/vim', { 'as': 'dracula' }

" Visual
Plug 'glepnir/dashboard-nvim'
"Plug 'beauwilliams/statusline.lua'


" Plug 'preservim/tagbar'
Plug 'rcarriga/nvim-notify'
"Plug 'vim-airline/vim-airline'
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'petertriho/nvim-scrollbar'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
"Plug 'kyazdani42/nvim-web-devicons'
"Plug 'romgrk/barbar.nvim'

call plug#end()
syntax enable
colorscheme dracula

" UI Visual Overhaul
:highlight WinSeparator guifg=None
set laststatus=3
set termguicolors
set colorcolumn=110
set visualbell
set number
set tabstop=4

" ToggleTerm Setup				
lua << EOF

require("toggleterm").setup()
require("noice").setup()
require('glow').setup()

EOF


" Windline ( status releated )
lua << EOF
local default = {
        filetypes={'default'},
        active={
                --- components...
        },
    inactive={
                --- components...
    }
}
local explorer = {
        filetypes = {'fern', 'NvimTree','netrw'},
        active = {
                {'  ', {'white', 'black'} },
        },
                --- show active components when the window is inactive
        always_active = true,
        --- It will display a last window statusline even that window should inactive
        show_last_status = true
}
---local windline = require('windline')
---windline.setup({
  ---  statuslines = {
                        ---require('wlsample.airline_anim')
    ---}
---})
EOF

" Scrollbar
lua << EOF
require("scrollbar").setup({
    show = true,
    set_highlights = true,
    folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
    max_lines = false, -- disables if no. of lines in buffer exceeds this
    handle = {
        text = " ",
        color = nil,
        cterm = nil,
        highlight = "CursorColumn",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
    },
    marks = {
        Search = {
            text = { "-", "=" },
            priority = 0,
            color = nil,
            cterm = nil,
            highlight = "Search",
        },
        Error = {
            text = { "-", "=" },
            priority = 1,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
            text = { "-", "=" },
            priority = 2,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
            text = { "-", "=" },
            priority = 3,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
            text = { "-", "=" },
            priority = 4,
            color = nil,
            cterm = nil,
            highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
            text = { "-", "=" },
            priority = 5,
            color = nil,
            cterm = nil,
            highlight = "Normal",
        },
    },
    excluded_buftypes = {
        "terminal",
    },
    excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
    },
    autocmd = {
        render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
        },
    },
    handlers = {
        diagnostic = true,
        search = false, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
    },
})
EOF
" notify
lua << EOF
require("bit")
require("notify")("My super important message")
require("telescope").load_extension("notify")

vim.notify = require("notify")
EOF


call nvim_notify("test", 1, {})

" vim Keybindings
let mapleader=','
:nnoremap <C-p> <Cmd>FZF<CR>

" vim-keysound
"let g:keysound_enable = 1
"let g:keysound_theme = 'default'
"let g:keysound_py_version = 3
"let g:keysound_volume = 500

" CHADTree
nnoremap <leader>v <cmd>CHADopen<cr>
nnoremap <leader>l <cmd>call setqflist([])<cr>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'CHADopen' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" ToggleTerm
nnoremap <leader>t :ToggleTerm<cr>

" bufferline
lua << EOF
require("bufferline").setup{
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    numbers = "none",
    close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
    right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
    -- NOTE: this plugin is designed with this icon in mind,
    -- and so changing this is NOT recommended, this is intended
    -- as an escape hatch for people who cannot bear it for whatever reason
    indicator_icon = '▎',
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    --- name_formatter can be used to change the buffer's label in the bufferline.
    --- Please note some names can/will break the
    --- bufferline so use this at your discretion knowing that it has
    --- some limitations that will *NOT* be fixed.
    name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
      -- remove extension from markdown files for example
      if buf.name:match('%.md') then
        return vim.fn.fnamemodify(buf.name, ':t:r')
      end
    end,
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics = "coc",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "("..count..")"
    end,
    -- NOTE: this will be called a lot so don't do any heavy processing here
    custom_filter = function(buf_number, buf_numbers)
      -- filter out filetypes you don't want to see
      if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
        return true
      end
      -- filter out by buffer name
      if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
        return true
      end
      -- filter out based on arbitrary rules
      -- e.g. filter out vim wiki buffer from tabline in your work repo
      if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
        return true
      end
      -- filter out by it's index number in list (don't show first buffer)
      if buf_numbers[1] ~= buf_number then
        return true
      end
    end,
    offsets = {{filetype = "CHADTree", text = "File Explorer" , text_align = "left"},{filetype = "ToggleTerm", text = "Terminal" , text_align = "left"}},
    color_icons = true, -- whether or not to add the filetype icon highlights
    show_buffer_icons = true, -- disable filetype icons for buffers
    show_buffer_close_icons = true,
    show_buffer_default_icon = true, -- whether or not an unrecognised filetype should show a default icon
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = "slant",
    enforce_regular_tabs = false,
    always_show_bufferline = true
    --sort_by = 'insert_after_current'
      -- add custom logic
      -- return buffer_a.modified > buffer_b.modified


  }

}
EOF
" DashBoard
let g:dashboard_default_executive ='telescope'
nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>

" Telescope
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


" clang linter
let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_c_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = 'cpplint'
" The following two lines are optional. Configure it to your liking!
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" Usablitty Overhaul
" set mouse=nv
