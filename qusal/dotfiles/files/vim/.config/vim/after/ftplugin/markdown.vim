" Author: Maxim Kim
" Source: https://vi.stackexchange.com/a/21689
function! MarkdownFold()
  let line = getline(v:lnum)

  " Regular headers
  let depth = match(line, '\(^#\+\)\@<=\( .*$\)\@=')
  if depth > 0
    " check syntax, it should be markdownH1-6
    let syncode = synstack(v:lnum, 1)
    if len(syncode) > 0 && synIDattr(syncode[0], 'name') =~ 'markdownH[1-6]'
        return ">" . depth
    endif
  endif

  " Setext style headings
  let prevline = getline(v:lnum - 1)
  let nextline = getline(v:lnum + 1)
  if (line =~ '^.\+$') && (nextline =~ '^=\+$') && (prevline =~ '^\s*$')
    return ">1"
  endif

  if (line =~ '^.\+$') && (nextline =~ '^-\+$') && (prevline =~ '^\s*$')
    return ">2"
  endif

  " frontmatter
  if (v:lnum == 1) && (line =~ '^----*$')
      return ">1"
  endif

  return "="
endfunction
