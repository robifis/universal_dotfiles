" ~/.vimrc

" Basic Settings
set number          " Show line numbers
set relativenumber  " Show relative line numbers
set mouse=a         " Enable mouse in all modes
set ignorecase      " Ignore case when searching
set smartcase       " But not if search pattern contains uppercase
set hlsearch        " Highlight search results
set incsearch       " Show search results incrementally
if has('termguicolors') " Check if termguicolors is supported
  set termguicolors   " Enable true color support
endif
set scrolloff=8     " Lines to keep above/below cursor
set sidescrolloff=8
set wrap!           " Toggle line wrapping (default off)
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab       " Use spaces instead of tabs

set undofile        " Persistent undo
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
set undodir=~/.vim/undodir
set noswapfile      " Don't use swapfiles
set nobackup        " Don't create backup files
set shortmess+=c    " Don't pass messages from |ins-completion-menu|.
set signcolumn=yes  " Always show signcolumn to prevent layout shifts
set wildmenu        " Enhanced command-line completion
set wildmode=longest:full,full " Command-line completion mode

" Leader key
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" --- vim-plug: Plugin Manager ---
" Install vim-plug if not already installed:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged') " Directory where plugins will be installed

" 1. Theme
Plug 'morhetz/gruvbox'

" 2. LSP, Autocompletion, Snippets (using CoC - Conqueror of Completion)
Plug 'neoclide/coc.nvim', {'branch': 'release'} " CoC requires Node.js installed

" 3. Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " For fzf itself
Plug 'junegunn/fzf.vim'                             " Vim bindings for fzf
    " Note: fzf (the command-line tool) needs to be installed on your system (sudo pacman -S fzf)
    "       ripgrep is recommended for :Rg (sudo pacman -S ripgrep)

" 4. File Manager / Explorer
Plug 'preservim/nerdtree'        " File system explorer
Plug 'Xuyuanp/nerdtree-git-plugin' " Git status indicators for NERDTree
Plug 'ryanoasis/vim-devicons'      " Adds file type icons (used by NERDTree and Airline)

" 5. Other Useful Plugins
Plug 'tpope/vim-fugitive'         " Git wrapper
Plug 'tpope/vim-commentary'      " Easy commenting (gcc, gc)
Plug 'vim-airline/vim-airline'       " Status line
Plug 'vim-airline/vim-airline-themes' " Themes for Airline

" Auto Pairs:
" Choose ONE of the following. `coc-pairs` is often sufficient if using CoC extensively.
Plug 'jiangmiao/auto-pairs'      " Standalone auto-pairs plugin
" If you prefer coc-pairs, ensure 'coc-pairs' is in g:coc_global_extensions and comment out the line above.

" Snippet Collection (often used with snippet engines like UltiSnips or coc-snippets)
Plug 'honza/vim-snippets' " A collection of snippets for various languages

call plug#end() " End of vim-plug section

" --- Enable Filetype specific plugins and indentation ---
filetype plugin indent on " Enable filetype detection, plugins, and indentation
syntax on             " Enable syntax highlighting (Vim's classic regex-based engine)
                      " (Note: Vim 8 does not have Treesitter like Neovim)

" --- Theme Configuration (Gruvbox) ---
if &termguicolors
  set termguicolors
endif
let g:gruvbox_contrast_soft = 1
colorscheme gruvbox
set background=dark

" --- NERDTree Configuration ---
if exists('g:plug_loaded.nerdtree')
  nnoremap <silent> <leader>e :NERDTreeToggle<CR> " Toggle NERDTree with <leader>e
  nnoremap <silent> <leader>ef :NERDTreeFind<CR>  " Open NERDTree to the current file's directory
  let g:NERDTreeShowHidden = 1 " Show hidden files
  let g:NERDTreeGitStatusIndicatorMapCustom = {
      \ "Modified"  : "✹",  "Staged"    : "✚",  "Untracked" : "✭",
      \ "Renamed"   : "➜",  "Unmerged"  : "═",  "Deleted"   : "✖",
      \ "Dirty"     : "✗",  "Ignored"   : "☒",  "Clean"     : "✔︎",
      \ 'Ahead'     : '⇡', 'Behind'    : '⇣', 'Conflicted': '≠' }
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " Quit Vim if NERDTree is the only window
endif

" --- CoC (Conqueror of Completion) Configuration ---
" LSP is handled by CoC.nvim. Syntax highlighting is Vim's default.
if exists('*coc#start')
  " Ensure 'coc-pairs' is in this list if you choose it over jiangmiao/auto-pairs
  let g:coc_global_extensions = [
    \ 'coc-snippets', 'coc-pairs', 'coc-json', 'coc-tsserver', 'coc-pyright',
    \ 'coc-rust-analyzer', 'coc-clangd', 'coc-vimlsp', 'coc-bash', 'coc-lua'
    \ ]
  " (Run :CocInstall <extension-name> for LSPs)

  " Keymappings for CoC (same as before)
  inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>"
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  if has('nvim'); inoremap <silent><expr> <c-space> coc#refresh(); else; inoremap <silent><expr> <c-@> coc#refresh();
  endif
  nmap <silent> gd <Plug>(coc-definition); nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation); nmap <silent> gr <Plug>(coc-references)
  nnoremap <silent> K :call ShowDocumentation()<CR>
  function! ShowDocumentation()
    if coc#util#has_float() | call coc#doc#show() | else | call feedkeys('K', 'in') |
    endif
  endfunction
  autocmd CursorHold * silent call CocActionAsync('highlight')
  nmap <leader>ca  <Plug>(coc-codeaction-cursor); xmap <leader>ca  <Plug>(coc-codeaction-selected)
  nmap <leader>rn <Plug>(coc-rename)
  command! -nargs=0 Format :call CocAction('format')
  nmap <leader>fm <Plug>(coc-format-selected); xmap <leader>fm <Plug>(coc-format-selected)
  nmap <silent> [g <Plug>(coc-diagnostic-prev); nmap <silent> ]g <Plug>(coc-diagnostic-next)
  nmap <leader>dl <Plug>(coc-diagnostic-info); nmap <leader>dq <Plug>(coc-diagnostic-quickfix)

  " Snippet keybindings for coc-snippets
  imap <C-j> <Plug>(coc-snippets-expand-jump)
  let g:coc_snippet_next = '<c-l>'; let g:coc_snippet_prev = '<c-h>'
endif

" --- fzf.vim Configuration ---
if exists('g:plug_loaded.fzf_vim')
  nnoremap <silent> <leader>ff :Files<CR>; nnoremap <silent> <leader>fg :Rg<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>; nnoremap <silent> <leader>fh :History<CR>
  nnoremap <silent> <leader>fco :Commits<CR>; nnoremap <silent> <leader>fgb :GBranches<CR>
  if has('nvim') || has('popupwin'); let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'border': 'rounded' } }; 
  endif
endif

" --- vim-airline Configuration ---
if exists('g:plug_loaded.vim-airline')
  let g:airline_theme = 'gruvbox'
  let g:airline_powerline_fonts = 1 " For Nerd Font icons
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#nerdtree#enabled = 1 " Integrate Airline with NERDTree
  let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
  let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
endif " <<< Endif for vim-airline block


" --- Other useful settings ---
if has("autocmd")
  autocmd! bufwritepost .vimrc source % | if exists(':PlugInstall') | PlugInstall --sync | endif
endif " <<< Endif for autocmd block

nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" --- End of .vimrc ---
