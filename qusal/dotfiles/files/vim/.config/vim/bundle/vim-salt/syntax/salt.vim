" Vim syntax file
" Language:     Salt States template
" Maintainer:   Seth House <seth@eseth.com>
" Last Change:  2023 Apr 17
" Source: https://github.com/vmware-archive/salt-vim/blob/master/syntax/sls.vim

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'yaml'
endif

if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif

runtime! syntax/yaml.vim
unlet b:current_syntax

let s:jinja_path = findfile("syntax/jinja.vim", &rtp, 1)
if s:jinja_path != ""
  runtime! syntax/jinja.vim
  unlet b:current_syntax
else
  runtime! syntax/django.vim
  unlet b:current_syntax
endif

if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif

" TODO: fix yamlBlockMappingKey not working with {{ jinja_variable }}
" Example key that fails: key {{ variable }}:
" Get its value: syn list yamlBlockMappingKey
" syn match yamlBlockMappingKey /\%#=1\s*\zs\%([^\-?:,[\]{}#&*!|>'"%@`\n\r\uFEFF \t]\|[?:\-]\%([^\n\r\uFEFF \t]\)\@=\)\%([^\n\r\uFEFF \t]#\|:[^\n\r\uFEFF \t]\|[^\n\r\uFEFF \t:#]\)*\%(\s\+\%([^\-?:,[\]{}#&*!|>'"%@`\n\r\uFEFF \t]\|[?:\-]\%([^\n\r\uFEFF \t]\)\@=\)\%([^\n\r\uFEFF \t]#\|:[^\n\r\uFEFF \t]\|[^\n\r\uFEFF \t:#]\)*\)*\ze\s*:\%(\s\|$\)/ contained nextgroup=yamlKeyValueDelimiter

" TODO: improve: keyword is not great when the key contains it: include-ab:
syn keyword saltInclude include extend containedin=yamlBlockMappingKey nextgroup=yamlKeyValueDelimiter contained

syn keyword saltSpecialArgs name names check_cmd listen listen_in onchanges onchanges_in onfail onfail_in onlyif prereq prereq_in require require_in unless use use_in watch watch_in containedin=yamlBlockMappingKey nextgroup=yamlKeyValueDelimiter contained

syn keyword saltErrors requires requires_in watches watches_in includes extends containedin=yamlBlockMappingKey contained

hi def link saltInclude Include
hi def link saltSpecialArgs Special
hi def link saltErrors Error

let b:current_syntax = "salt"
