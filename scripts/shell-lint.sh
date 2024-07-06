#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

## Credits: https://unix.stackexchange.com/a/483876

# shellcheck disable=SC2086
set -eu

command -v git >/dev/null || { echo "Missing program: git" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1
./scripts/requires-program.sh shellcheck file

find_tool="$(./scripts/best-program.sh fd fdfind find)"

if test -n "${1-}"; then
  files=""
  sh_files=""
  for f in "$@"; do
    test -f "$f" || continue
    case "${f}" in
      */zsh/*) continue;;
      *.yml|*.yaml|*.vim|*.sls|*.top|*.toml|*.timer|*.service|*.socket| \
      *.spec|*/config|*.txt|*/version|*.sources|*.asc|*.repo) continue;;
      */rc.local) sh_files="$sh_files $f"; continue;;
      *) files="$files $f"
    esac
  done
  files="$(file $files | awk -F ":" '/ shell script,/{ print $1 }')"
  if test -z "$files" && test -z "$sh_files"; then
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
              --exec-batch file | awk -F ":" '/ shell script,/{ print $1 }')"
    ## No Shebang
    sh_files="$(${find_tool} rc.local salt/ --type=f)"
    ;;
  find)
    files="$(find scripts/ salt/ -not \( -path "*/zsh" -prune \) -type f \
             -exec file {} \+ | awk -F ":" '/ shell script,/{ print $1 }')"
    ## No Shebang
    sh_files="$(find salt/ -type f -name "rc.local")"
    ;;
esac

files="$(echo "$files" | sort -u)"
sh_files="$(echo "$sh_files" | sort -u)"
test -z "${files}" || shellcheck ${files}
test -z "${sh_files}" || shellcheck -s sh ${sh_files}
