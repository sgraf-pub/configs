syntax on
filetype indent plugin on

set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set modeline
set smarttab
set autoindent

set background=dark

if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

set list listchars=tab:»·,trail:·

