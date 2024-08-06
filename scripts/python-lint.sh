#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC2086
set -eu

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel
./scripts/requires-program.sh pylint

find_tool="$(./scripts/best-program.sh fd fdfind find)"

if test -n "${1-}"; then
  files=""
  for f in "${@}"; do
    test -f "${f}" || continue
    extension="${f##*.}"
    case "${extension}" in
      py) files="${files} ${f}";;
      *) continue
        ;;
    esac
  done
  test -n "${files}" || exit 0
  exec pylint ${files}
fi

case "${find_tool}" in
  fd|fdfind) files="$(${find_tool} . -H -t f -e py)";;
  find) files="$(find . -type f -name "*.py")";;
  *) printf '%s\n' "Unsupported find tool" >&2; exit 1;;
esac

exec pylint ${files}
