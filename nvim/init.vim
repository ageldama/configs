" ~/.vimrc
"
"  ageldama@gmail.com : 2006-11-16
"  ageldama@gmail.com : 2017-08-05
"  ageldama@gmail.com : 2018-03-24 
"

" https://github.com/VundleVim/Vundle.vim/issues/769#issue-188457119
" START - Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
  echo "Installing Vundle.."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
if iCanHazVundle == 0
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :PluginInstall
endif
" END - Setting up Vundle - the vim plugin bundler

" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
"
" The bundles you install will be listed here
"
filetype plugin indent on
"
Bundle 'schickling/vim-bufonly'
                              " <esc>:Bonly
Bundle 'wesQ3/vim-windowswap'
                              " <leader>ww

Bundle 'junegunn/fzf.vim'
Bundle 'junegunn/fzf'

Bundle 'tpope/vim-fugitive'
Bundle 'kablamo/vim-git-log'
Bundle 'gregsexton/gitv'

Bundle 'jlanzarotta/bufexplorer'
                              " <leader>be

Bundle 'bling/vim-airline'

Bundle 'scrooloose/nerdtree'


Bundle 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<leader>\'



Bundle 'rbgrouleff/bclose.vim'

" grep, ag,...

"Bundle 'mileszs/ack.vim'

" FIXME: <leader>* conflicts
"Bundle 'https://github.com/bronson/vim-visual-star-search'


" use ag for recursive searching so we don't find 10,000 useless hits inside node_modules
if 1
  " NOT WORKING.
  Bundle 'https://github.com/rking/ag.vim'

  nnoremap <leader>; :call ag#Ag('ag', '--literal ' . shellescape(expand("<cword>")))<CR>
  "vnoremap <leader>! :<C-u>call VisualStarSearchSet('/', 'raw')<CR>:call ag#Ag('grep', '--literal ' . shellescape(@/))<CR>
end


"
Bundle 'godlygeek/tabular'
"Bundle 'vim-syntastic/syntastic.git'
Bundle 'w0rp/ale'


"Bundle 'Shougo/neocomplete.vim'

" Markdown / Writting
Bundle 'reedes/vim-pencil'
Bundle 'tpope/vim-markdown'
Bundle 'jtratner/vim-flavored-markdown'

" Color theme.
"Bundle 'colepeters/spacemacs-theme.vim'

set t_Co=256

if (has("termguicolors"))
  set termguicolors
endif

color default
set bg=dark

"
Bundle 'junegunn/vim-peekaboo'
              " kill-rings, registers. @

Bundle 'maxbrunsfeld/vim-yankstack'
              " M-p, S-M-p, just like emacs.

Bundle 'terryma/vim-multiple-cursors'
              " C-n, C-x...

Bundle 'urbainvaes/vim-remembrall'
              " just like which-key in emacs.

Bundle 'mhinz/vim-startify'

Bundle 'pangloss/vim-javascript'

Bundle 'vim-scripts/occur.vim'

Bundle 'tpope/vim-surround'

Bundle 'tpope/vim-abolish'

Bundle 'https://github.com/RRethy/vim-illuminate'



"------------------------------------------------------------------------------

set nopaste


" The Silver Searcher
if executable('ag')
  "let g:ack_prg = 'ag --vimgrep'

  " Use ag over grep
  let g:grep_prg="ag --vimgrep"

  let g:ag_prg="ag --column --hidden"    " --hidden lets ag search hidden files but ignore ~/.agignore

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  let g:ctrlp_mruf_case_sensitive = 0

endif



" use only Vim settings (instead of vi)
set nocompatible

" 문법강조
syntax on

" 줄번호
set number

" Row/Col?
set ruler

" 비쥬얼벨
set visualbell

" 자동들여쓰기 및 탭크기랑 <<, >> 크기조절.
set smartindent
set autoindent    " 새로운 행 시작할때, 이전행의 indent처럼.
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab	" tab대신 스페이스!

set nowrap

" modeline 향수
set modeline

set showmode
set showcmd

" 검색
set hls
set incsearch

"set ignorecase	" 대소문자무시
"set wildignorecase

set scs	" smart-search

" 백스페이스 : 언제나, 심지어 내가 방금 입력한게 아닌 것도 지우도록-_-
set backspace=indent,eol,start


" 폰트
"if has('gui_running')
"set guifont=Consolas:h14:cANSI
"set guifont=Bitstream_Vera_Sans_Mono:h14:cANSI

" 메뉴&툴바
set guioptions=m

" 파일인코딩
set fencs=utf8,euc-kr

" 파일타입설정
filetype on
filetype indent on
filetype plugin on

" airline, lightline
set laststatus=2


" minibufexplorer
"map <Leader>mbe :MBEOpen<cr>
"map <Leader>mbc :MBEClose<cr>
"map <Leader>mbt :MBEToggle<cr>

" ALE 
if 1
    let g:ale_sign_error = '>>'
    let g:ale_sign_warning = '--'
    let g:airline#extensions#ale#enabled = 1
    let g:ale_completion_enabled = 1
    let g:ale_enabled = 1
    let g:ale_open_list = 0
    autocmd BufRead,BufNewFile *.{java} let b:ale_enabled=0
endif

" Syntastic
if 0
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
endif

" PerlTidy
"define :Tidy command to run perltidy on visual selection || entire buffer"
command -range=% -nargs=* PerlTidy <line1>,<line2>!perltidy
"run :Tidy on entire buffer and return cursor to (approximate) original position"
fun DoPerlTidy()
    let Pos = line2byte( line( "." ) )
     :PerlTidy
    exe "goto " . Pos
endfun

" Clipboard
set clipboard=unnamed


" Settings for Writting
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'

" Vim-pencil Configuration
augroup pencil
  autocmd!
  autocmd FileType markdown,md,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
augroup END

" NERDTree
map <C-n> :NERDTreeToggle<CR>


"
fun ShowMap()
  redir @" | silent map | redir END | new | put!
endfun

"
let mapleader = "\<Space>"

noremap <leader>b :BufExplorer<CR>
noremap <leader>p :CtrlP<CR>
noremap <leader>n :NERDTreeFind<CR>

" fzf bindings
noremap <leader>f :Files<CR>
noremap <leader>g :GFiles<CR>
noremap <leader>G :GFiles?<CR>
noremap <leader>zb :Buffers<CR>
noremap <leader>za :Ag<space>
noremap <leader>m :Marks<CR>
noremap <leader>h :Helptags<CR>

" autoread
set autoread                                                                                                                                                                                    
au CursorHold * checktime  
set updatetime=300 " set updatetime to shorter value

" illuminate
let g:Illuminate_delay = 250

"EOF
