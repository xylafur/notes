colorscheme elflord

syntax enable

set tabstop=4
set softtabstop=4
set expandtab

set autoindent

set relativenumber
set number 

set showcmd
set cursorline

set wildmenu "visual autocomplete for command menu

set showmatch	"shows matching parentesis 

set incsearch "search as characters are entered
set hlsearch	"highlight matches

set colorcolumn=80  "red vertical bar at 80 x


inoremap jk <esc>

"installed pluggins

nmap qp :NERDTreeToggle<CR>

"pathogen, vim plugin manager
execute pathogen#infect()
call pathogen#helptags()

set tags=tags;/

"adds the file name to the bottom
set statusline+=%F
set laststatus=2

"syntastic, syntax highlighter
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_flake8_exec = 'python3'
let g:syntastic_python_flake8_args = ['-m', 'flake8']
