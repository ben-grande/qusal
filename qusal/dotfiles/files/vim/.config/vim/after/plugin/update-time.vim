" File: update-time.vim
" Author: QianChenglong <qianchenglong2012@gmail.com>
" Create Time: 2013-12-04 19:36:21 CST
" Last Change:  2023 Oct 21
" Description: Automatic update Last Change time
" SPDX-FileCopyrightText: 2013 QianChenglong <qianchenglong2012@gmail.com>
" SPDX-License-Identifier: Vim

if exists("g:loaded_update_time")
  finish
endif
let g:loaded_update_time = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:update_time_time_stamp_leader')
  let s:time_stamp_leader = 'Last Change: '
else
  let s:time_stamp_leader = g:update_time_time_stamp_leader
endif

if !exists('g:update_time_time_format')
  let s:time_format = '%Y-%m-%d %H:%M:%S %Z'
else
  let s:time_format = g:update_time_time_format
endif

if !exists("g:update_time_begin_line")
  let s:begin_line = 0
else
  let s:begin_line = g:update_time_begin_line
endif

if !exists('g:update_time_end_line')
  let s:end_line = 10
else
  let s:end_line = g:update_time_end_line
endif

if !exists('g:update_time_enable')
  let s:update_time_enable = 1
else
    let s:update_time_enable = g:update_time_enable
endif
"}}}
" SECTION: Funtions"{{{
fun Update_time_update()
  if ! &modifiable
    return
  endif
  if ! s:update_time_enable
    return
  endif
  let bufmodified = getbufvar('%', '&mod')
  if ! bufmodified
    return
  endif
  let pos = line('.').' | normal! '.virtcol('.').'|'
  if pos == 1
    return
  endif
  exe s:begin_line
  let line_num = search(s:time_stamp_leader, '', s:end_line)
  if line_num > 0
    let line = getline(line_num)
    let line = substitute(line, s:time_stamp_leader . '\zs.*', ' ' . strftime(s:time_format), '')
    call setline(line_num, line)
  endif
  exe pos
endf

fun Update_time_toggle()
  let s:update_time_enable = !s:update_time_enable
endf

com! -nargs=0 UpdateTimeToggle silent call Update_time_toggle()

autocmd BufWritePre * silent call Update_time_update()

let &cpo = s:save_cpo
unlet s:save_cpo
