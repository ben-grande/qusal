#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC2086
set -eu

command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1
./scripts/requires-program.sh mdl

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
    extension="${f##*.}"
    case "$extension" in
      md) files="$files $f";;
      *) continue;;
    esac
  done
  test -n "$files" || exit 0
  exec mdl ${files}
fi

case "${find_tool}" in
  fd|fdfind) files="$(${find_tool} . --extension=md)";;
  find) files="$(find minion.d/ -type f -name "*.md")";;
esac

exec mdl ${files}
