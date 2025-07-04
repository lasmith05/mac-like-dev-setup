" Vim Configuration (.vimrc)
" Copy this to ~/.vimrc

" Enable mouse support
set mouse=a
set ttymouse=xterm2

" Basic settings
set number              " Show line numbers
set relativenumber      " Show relative line numbers
set syntax=on           " Enable syntax highlighting
set tabstop=4           " Tab width
set shiftwidth=4        " Indent width
set expandtab           " Use spaces instead of tabs
set smartindent         " Smart indentation
set autoindent          " Auto indentation
set wrap                " Enable line wrapping
set linebreak           " Break lines at word boundaries
set showmatch           " Show matching brackets
set incsearch           " Incremental search
set hlsearch            " Highlight search results
set ignorecase          " Case insensitive search
set smartcase           " Case sensitive when using uppercase
set wildmenu            " Enhanced command completion
set wildmode=longest,list,full
set backspace=indent,eol,start
set encoding=utf-8
set fileencoding=utf-8

" Visual settings
set background=dark
set termguicolors       " Enable true colors
set cursorline          " Highlight current line
set laststatus=2        " Always show status line
set ruler               " Show cursor position
set showcmd             " Show command in bottom right
set noshowmode          " Don't show mode (status line will show it)

" File handling
set autoread            " Automatically read changes from disk
set backup              " Enable backups
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undofile            " Persistent undo
set undodir=~/.vim/undo//

" Create directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, 'p')
endif
if !isdirectory(&directory)
    call mkdir(&directory, 'p')
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
endif

" Key mappings
" Use jj to exit insert mode
inoremap jj <Esc>

" Clear search highlighting
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows with arrow keys
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" Move lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Better copy/paste
vnoremap <C-c> "+y
nnoremap <C-v> "+p
inoremap <C-v> <C-r>+

" Save with Ctrl+s
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quit with Ctrl+q
nnoremap <C-q> :q<CR>

" File type specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType json setlocal tabstop=2 shiftwidth=2 expandtab

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Status line
set statusline=%t       " Tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " File encoding
set statusline+=%{&ff}] " File format
set statusline+=%h      " Help file flag
set statusline+=%m      " Modified flag
set statusline+=%r      " Read only flag
set statusline+=%y      " Filetype
set statusline+=%=      " Left/right separator
set statusline+=%c,     " Cursor column
set statusline+=%l/%L   " Cursor line/total lines
set statusline+=\ %P    " Percent through file

" Highlight extra whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable spell checking for text files
autocmd FileType text,markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" Set comment strings for different file types
autocmd FileType python setlocal commentstring=#\ %s
autocmd FileType javascript setlocal commentstring=//\ %s
autocmd FileType vim setlocal commentstring=\"\ %s