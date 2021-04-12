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

" La numeracion relativa es muy util. Sin embargo, se habilita un switch para los
" numeros relativos. Esto se realiza con F5.
nmap <F5> :set invrelativenumber<CR>
imap <F5> <ESC> :set invrelativenumber<CR>a
