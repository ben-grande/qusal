" Vim filetype plugin file
" Language:             YAML (YAML Ain't Markup Language)
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se> (inactive)
" Last Change:  2023 Oct 21
" SPDX-FileCopyrightText: 2020 Nikolai Weibull <now@bitwi.se>
" SPDX-License-Identifier: Vim

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setl tw< com< cms< et< fo<"

" https://salt-lint.readthedocs.io/en/latest/rules/formatting/#204
setlocal textwidth=160
setlocal comments=:# commentstring=#\ %s expandtab
setlocal formatoptions-=t formatoptions+=croql

if !exists("g:yaml_recommended_style") || g:yaml_recommended_style != 0
  let b:undo_ftplugin ..= " sw< ts< sts<"
  setlocal shiftwidth=2 tabstop=2 softtabstop=2
endif

let &cpo = s:cpo_save
unlet s:cpo_save
