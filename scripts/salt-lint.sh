#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC2086
set -eu

command -v salt-lint >/dev/null ||
  { printf >&2 "Missing program: salt-lint\n"; exit 1; }
command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1

possible_conf="${PWD}/.salt-lint"
conf=""
test -f "${possible_conf}" && conf="-c ${possible_conf}"

find_tool="find"
if command -v fd; then
  find_tool="fd"
elif command -v fdfind >/dev/null; then
  find_tool="fdfind"
fi

if test -n "${1-}"; then
  files=""
  for f in "$@"; do
    test -f "$f" || continue
    extension="$(echo "$f" | awk -F '.' '{print $NF}')"
    case "$extension" in
      top|sls) files="$files $f";;
      *) continue;;
    esac
  done
  test -n "$files" || exit 0
  exec salt-lint ${conf} ${files}
fi

case "${find_tool}" in
  fd|fdfind) files="$(${find_tool} . minion.d/ --extension=conf) $(${find_tool} . salt/ --max-depth=2 --type=f --extension=sls --extension=top | sort -d)";;
  find) files="$(find minion.d/ -type f -name "*.conf") $(find salt/* -maxdepth 2 -type f \( -name '*.sls' -o -name '*.top' \) | sort -d)";;
esac

exec salt-lint ${conf} ${files}
