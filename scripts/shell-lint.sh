#!/bin/sh

## SPDX-FileCopyrightText: 2018 Andreas Kusalananda <https://github.com/kusalaananda>
## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

## Credits: https://unix.stackexchange.com/a/483876

# shellcheck disable=SC2086
set -eu

command -v shellcheck >/dev/null ||
  { printf >&2 "Missing program: shellcheck\n"; exit 1; }
command -v file >/dev/null ||
  { printf >&2 "Missing program: file\n"; exit 1; }
command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1

if command -v fd; then
  find_tool="fd"
elif command -v fdfind >/dev/null; then
  find_tool="fdfind"
fi

if test -n "${1-}"; then
  files=""
  sh_files=""
  for f in "$@"; do
    test -f "$f" || continue
    if test "${f##*/}" = "rc.local"; then
      sh_files="$sh_files $f"
      continue
    fi
    case $( file -bi "$f" ) in
      (*/x-shellscript*) files="$files $f";;
    esac
  done
  if test -n "$files" || test -n "$sh_files"; then
    exit 0
  fi
  test -z "$files" || shellcheck ${files}
  test -z "$sh_files" || shellcheck -s sh ${sh_files}
  exit
fi

case "${find_tool}" in
  fd|fdfind)
    # shellcheck disable=2016,2215
    files="$(${find_tool} . scripts/ salt/ --hidden --exclude=zsh --type=f \
              --exec sh -c '
              case $( file -bi "$1" ) in (*/x-shellscript*)
                printf "%s\n" "$1";; esac' sh)"
    ## No Shebang
    sh_files="$(${find_tool} rc.local salt/ --type=f)"
    ;;
  find)
    files="$(find scripts/ salt/ -not \( -path "*/zsh" -prune \) -type f -exec sh -c '
              case $( file -bi "$1" ) in (*/x-shellscript*) exit 0;; esac
              exit 1' sh {} \; -print)"
    ## No Shebang
    sh_files="$(find salt/ -type f -name "rc.local")"
    ;;
esac

files="$(echo "$files" | sort -u)"
sh_files="$(echo "$sh_files" | sort -u)"
shellcheck ${files}
shellcheck -s sh ${sh_files}
