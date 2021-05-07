let g:LanguageClient_serverCommands = {
    \ 'css': ['css-languageserver', '--stdio'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ 'rust': ['rls'],
    \ 'sql': ['sql-language-server','up','--method','stdio'],
    \ }
