#!/bin/sh
# shellcheck disable=SC2086
set -eu

group="qusal"

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

case "${find_tool}" in
  fd|fdfind)
    # shellcheck disable=2016,2215
    files="$(${find_tool} . "${group}"/ --hidden --exclude=zsh --type=f \
              --exec sh -c '
              case $( file -bi "$1" ) in (*/x-shellscript*)
                printf "%s\n" "$1";; esac' sh)"
    files="${files} $(${find_tool} . --max-depth=1 --type=f --extension=sh)"
    ;;
  find)
    ## https://unix.stackexchange.com/a/483876
    files="$(find "${group}"/ -not \( -path "*/zsh" -prune \) -type f -exec sh -c '
              case $( file -bi "$1" ) in (*/x-shellscript*) exit 0;; esac
              exit 1' sh {} \; -print)"
    files="${files} $(find . -maxdepth 1 -type f -name "*.sh")"
    ;;
esac

shellcheck ${files}
