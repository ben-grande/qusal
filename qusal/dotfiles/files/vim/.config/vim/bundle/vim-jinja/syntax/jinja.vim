" Vim syntax file
" Language:    Jinja template
" Maintainer:  Armin Ronacher <armin.ronacher@active-4.com>
" Last Change:  2023 Oct 21
" Version:     1.1
" Credits:      https://github.com/Glench/Vim-Jinja2-Syntax/blob/master/syntax/jinja.vim
" SPDX-FileCopyrightText: 2020 Armin Ronacher <armin.ronacher@active-4.com>
" SPDX-License-Identifier: Vim

if exists("b:current_syntax")
  finish
endif

if !exists('g:jinja_syntax_html')
  let g:jinja_syntax_html=1
endif

if !exists("main_syntax")
  let main_syntax = 'jinja'
endif

" Pull in the HTML syntax.
if g:jinja_syntax_html
  let ext = expand('%:e')
  if ext !~ 'htm\|nunj|jinja\|j2' &&
        \ findfile(ext . '.vim', $VIMRUNTIME . '/syntax') != ''
    execute 'runtime! syntax/' . ext . '.vim'
  else
    runtime! syntax/html.vim
  endif
  unlet b:current_syntax
endif

syn case match
syn sync minlines=10

" Jinja template built-in tags and parameters (without filter, macro, is and
" raw, they have special treatment)
syn keyword jinjaStatement containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained and if else in not or recursive as import

syn keyword jinjaStatement containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained is filter skipwhite nextgroup=jinjaFilter
syn keyword jinjaStatement containedin=jinjaTagBlock contained macro skipwhite nextgroup=jinjaFunction
syn keyword jinjaStatement containedin=jinjaTagBlock contained block skipwhite nextgroup=jinjaBlockName

" Variable Names
syn match jinjaVariable containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn keyword jinjaSpecial containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained false true none False True None loop super caller varargs kwargs

" Filters
syn match jinjaOperator "|" containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained skipwhite nextgroup=jinjaFilter
syn match jinjaFilter contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match jinjaFunction contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn match jinjaBlockName contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template constants
syn region jinjaString containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained start=/"/ skip=/\(\\\)\@<!\(\(\\\\\)\@>\)*\\"/ end=/"/
syn region jinjaString containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained start=/'/ skip=/\(\\\)\@<!\(\(\\\\\)\@>\)*\\'/ end=/'/
syn match jinjaNumber containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[0-9]\+\(\.[0-9]\+\)\?/

" Operators
syn match jinjaOperator containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[+\-*\/<>=!,:]/
syn match jinjaPunctuation containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /[()\[\]]/
syn match jinjaOperator containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained /\./ nextgroup=jinjaAttribute
syn match jinjaAttribute contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template tag and variable blocks
syn region jinjaNested matchgroup=jinjaOperator start="(" end=")" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaNested matchgroup=jinjaOperator start="\[" end="\]" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaNested matchgroup=jinjaOperator start="{" end="}" transparent display containedin=jinjaVarBlock,jinjaTagBlock,jinjaNested contained
syn region jinjaTagBlock matchgroup=jinjaTagDelim start=/{%[-+]\?/ end=/[-+]\?%}/ containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested,jinjaComment

syn region jinjaVarBlock matchgroup=jinjaVarDelim start=/{{-\?/ end=/-\?}}/ containedin=ALLBUT,yamlComment,jinjaTagBlock,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested,jinjaComment

" Jinja template 'raw' tag
syn region jinjaRaw matchgroup=jinjaRawDelim start="{%\s*raw\s*%}" end="{%\s*endraw\s*%}" containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString,jinjaComment

" Mark illegal characters within tag and variables blocks
syn match jinjaTagError contained "#}\|{{\|[^%]}}\|[&#]"
syn match jinjaVarError contained "#}\|{%\|%}\|[<>!&#%]"

" Block start keywords.  A bit tricker.  We only highlight at the start of a
" tag block and only if the name is not followed by a comma or equals sign
" which usually means that we have to deal with an assignment.
syn match jinjaStatement containedin=jinjaTagBlock contained /\({%[-+]\?\s*\)\@<=\<[a-zA-Z_][a-zA-Z0-9_]*\>\(\s*[,=]\)\@!/

" and context modifiers
syn match jinjaStatement containedin=jinjaTagBlock contained /\<with\(out\)\?\s\+context\>/

" Keywords to highlight within comments
syn keyword jinjaTodo contained TODO FIXME XXX
syn cluster jinjaBlocks add=jinjaTagBlock,jinjaVarBlock,jinjaCommentBlock

" Jinja comments
syn region jinjaComment display oneline matchgroup=jinjaCommentDelim containedin=@jinjaCommentDelim start='\%\(^\|\s\)#' end='$'
syn region jinjaComment matchgroup=jinjaCommentDelim start="{#" end="#}" containedin=ALLBUT,jinjaTagBlock,jinjaVarBlock,jinjaString contains=jinjaComment keepend extend

" Define the default highlighting.
hi def link jinjaPunctuation jinjaOperator
hi def link jinjaAttribute jinjaVariable
hi def link jinjaFunction jinjaFilter

hi def link jinjaTagDelim jinjaTagBlock
hi def link jinjaVarDelim jinjaVarBlock
hi def link jinjaCommentDelim jinjaComment
hi def link jinjaCommentBlock jinjaComment
hi def link jinjaCommentLine jinjaComment
hi def link jinjaRawDelim jinja

hi def link jinjaSpecial Special
hi def link jinjaOperator Normal
hi def link jinjaRaw Normal
hi def link jinjaTagBlock PreProc
hi def link jinjaVarBlock PreProc
hi def link jinjaStatement Statement
hi def link jinjaFilter Function
hi def link jinjaBlockName Function
hi def link jinjaVariable Identifier
hi def link jinjaString Constant
hi def link jinjaNumber Constant
hi def link jinjaComment Comment

let b:current_syntax = "jinja"

if main_syntax ==# 'jinja'
  unlet main_syntax
endif
