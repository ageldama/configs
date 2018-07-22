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
"Bundle 'davidhalter/jedi-vim'
Bundle 'tpope/vim-fugitive'
"Bundle 'fholgado/minibufexpl.vim'
Bundle 'jlanzarotta/bufexplorer'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'rbgrouleff/bclose.vim'
Bundle 'mileszs/ack.vim'
Bundle 'godlygeek/tabular'
"Bundle 'vim-syntastic/syntastic.git'
Bundle 'w0rp/ale'

" Golang
"Bundle 'fatih/vim-go'
"Bundle 'majutsushi/tagbar'


"------------------------------------------------------------------------------

set paste


" The Silver Searcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep'

  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!



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

" wrap? 그냥 보이는 것만 설정합니다.
set wrap

" textwidth : 자동으로 행을 자르기. 0이면 끄기.
set textwidth=250

" modeline 향수
set modeline

set showmode
set showcmd

" 검색
set hls
set incsearch
set ignorecase	" 대소문자무시
set scs	" smart-search

" 백스페이스 : 언제나, 심지어 내가 방금 입력한게 아닌 것도 지우도록-_-
set backspace=indent,eol,start


" 폰트
"set guifont=Consolas:h14:cANSI
"set guifont=Bitstream_Vera_Sans_Mono:h14:cANSI

" 메뉴&툴바
set guioptions=m

" 색상설정
"color koehler
set t_Co=256
"set t_AB=^[[48;5;%dm
"set t_AF=^[[38;5;%dm
if has('gui_running')
    set guifont=Noto\ Sans\ Mono\ CJK\ KR\ 10
    "set guifont=Inconsolata\ Medium\ 12
	"set guifont="Noto Sans Mono CJK KR 14"
    color darkblue
    set bg=light
else
    color default
    set bg=dark
endif


" 파일인코딩
set fencs=utf8,euc-kr

" 파일타입설정
filetype on
filetype indent on
filetype plugin on

" airline
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




"EOF
