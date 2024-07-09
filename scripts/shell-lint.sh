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

exit_code=0
find_tool="$(./scripts/best-program.sh fd fdfind find)"

show_long_lines(){
  tty_stderr=0
  if test -t 2; then
    tty_stderr=1
  fi
  awk -v color="${tty_stderr}" '
    BEGIN {
      MAGENTA=""
      GREEN=""
      RESET=""
      if (color == 1) {
        MAGENTA="\033[1;35m"
        GREEN="\033[1;32m"
        RESET="\033[0m"
      }
    }
    {
    nlines++;
    if (length > 78 && !/^\s*#.*(:\/\/|SPDX-)/) {
      exit_code=1
      prefix = MAGENTA FILENAME RESET ":" GREEN FNR RESET
      print prefix ": line too long: " length " > 78" >"/dev/stderr"
      if (nlines==NR) { if (exit_code==1) { exit 1; }; }
    }
    if (nlines==NR) { if (exit_code==1) { exit 1; }; }
  }
  ' "${@}" >&2
}

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
  if test -n "${files}" || test -n "${sh_files}"; then
    show_long_lines ${files} ${sh_files} || exit_code=1
  fi
  if test -n "${files}"; then
    shellcheck ${files} || exit_code=1
  fi
  if test -n "${sh_files}"; then
    shellcheck -s sh ${sh_files} || exit_code=1
  fi
  exit "${exit_code}"
fi

case "${find_tool}" in
  fd|fdfind)
    # shellcheck disable=2016,2215
    files="$(${find_tool} . scripts/ salt/ -H -E zsh -t f -X file |
      awk -F ":" '/ shell script,/{ print $1 }')"
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

show_long_lines ${files} ${sh_files} || exit_code=1
shellcheck ${files} || exit_code=1
if test -n "$sh_files"; then
  shellcheck -s sh ${sh_files} || exit_code=1
fi
exit "${exit_code}"
