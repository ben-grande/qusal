" Credits:    https://github.com/Glench/Vim-Jinja2-Syntax/blob/master/ftplugin/jinja.vim
" SPDX-FileCopyrightText: 2020 Glench <https://github.com/Glench>
" SPDX-License-Identifier: Vim

if exists('b:did_ftplugin')
  finish
endif

" Setup matchit.
if exists('loaded_matchit')
  let b:match_ignorecase = 1
  let b:match_skip = 's:Comment'
  " From ftplugin/html.vim, plus block tag matching.
  " With block tags the following is optional:
  "   - "+": disable the lstrip_blocks (only at start)
  "   - "-": the whitespaces before or after that block will be removed
  let b:match_words = '<:>,' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,' .
        \ '{%[-+]\? *\%(end\)\@!\(\w\+\)\>.\{-}%}:{%-\? *end\1\>.\{-}%}'
endif
