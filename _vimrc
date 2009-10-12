" ~/.vimrc
"
"  ageldama@gmail.com : 2006-11-16 12:36
"
"  plugin: vcscommand taglist bufexplorer
"

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
"set autoindent
set noautoindent
"set smartindent
set nosmartindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab	" tab대신 스페이스!

" wrap? 그냥 보이는 것만 설정합니다.
set wrap

" textwidth : 자동으로 행을 자르기. 0이면 끄기.
set textwidth=999999

" modeline 향수
set showmode
set showcmd

" 검색
set hls
set incsearch
set ignorecase	" 대소문자무시
set scs	" smart-search

" 백스페이스 : 언제나, 심지어 내가 방금 입력한게 아닌 것도 지우도록-_-
set backspace=2

" 폰트
"set guifont=Consolas:h14:cANSI
set guifont=Bitstream_Vera_Sans_Mono:h14:cANSI

" 메뉴&툴바
set guioptions=m

" 색상설정
color koehler
set bg=dark

" 파일인코딩
set fencs=utf8,euc-kr

" 파일타입설정
filetype on
filetype indent on
filetype plugin on

" taglist
"let Tlist_Ctags_Cmd="ctags.exe"
nmap <F12> :TlistToggle<CR>

nmap <F10> :FuzzyFinderFile<CR>

" abbrevs
"abbr #b /************************************************************************
"abbr #e  ************************************************************************/

"abbr hosts C:\windows\system32\drivers\etc\hosts

"iab AGDTTM <c-r>=strftime("%Y-%m-%d %H:%M")<cr>
iab @TIME@ <c-r>=strftime("%Y-%m-%d %H:%M:%S")<cr>


iab @PY@ # vim: fileencoding=utf-8 autoindent expandtab sw=4 ts=4 :<cr>

"" io-language
" ~/.vim/syntax/io.vim이 있을때...
au BufNewFile,BufRead *.io setf io 


"EOF
