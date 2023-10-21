" Credits:    https://github.com/lepture/vim-jinja/blob/master/ftdetect/jinja.vim
" SPDX-FileCopyrightText: 2020 Lepture <https://github.com/lepture>
" SPDX-License-Identifier: Vim

" Figure out which type of hilighting to use for html.
function! s:SelectHTML()
  let n = 1
  while n < 50 && n <= line("$")
    " check for jinja
    if getline(n) =~ '{{.*}}\|{%-\?\s*\(end.*\|extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
      setfiletype jinja.html
      return
    endif
    let n = n + 1
  endwhile
endfunction

autocmd BufNewFile,BufRead *.{html,htm,nunjucks,nunjs,njk}
      \ call s:SelectHTML()

autocmd BufNewFile,BufRead *.{jinja,jinja2,j2,tera}
      \ setfiletype jinja
