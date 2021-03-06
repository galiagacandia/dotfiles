" CONFIGURACION DE VIM
" ====================
set nocompatible		" deshabilita el modo de compatibilidad con vi
set history=1000		" incrementa el tamaño para el historico

" Persistencia del undofile, para recuperar cambios realizados despues de salir de VIM
set undofile
set undodir=~/.vim/undodir

set noshowmode
set laststatus=1		" siempre muestra el statusbar
set wildmenu			" habilita el visual wildmenu, para completar el comando
set wildmode=longest:list,full	" la segunda pestaña se completara con la primera coincidencia completa y abrira el menu salvaje

set nowrap			" no parta lineas largas
set number			" muestra los numeros de linea
set showmatch			" resalta los parentesis y brackets que coincidan

" Configuracion de identado
set autoindent			" Siempre activo

" Configuracion de la codificacion de archivos
set encoding=utf-8
set backspace=indent,eol,start	" backspace siempre funciona en el modo de insercion
set hidden

" Atajos para el cambio entre buffers
map <C-N> :bnext<CR>
map <C-P> :bprev<CR>
imap <C-N> <Esc>:bnext<CR>i
imap <C-P> <Esc>:bprev<CR>i

" La tecla mapleader
let mapleader=","

" La numeracion relativa es muy util. Sin embargo, se habilita un switch para los
" numeros relativos. Esto se realiza con F5.
nmap <F5> :set invrelativenumber<CR>
imap <F5> <ESC> :set invrelativenumber<CR>a
