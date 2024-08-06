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
./scripts/requires-program.sh mdl

extra_files_rules="~MD002,~MD012,~MD022,~MD032,~MD041"
find_tool="$(./scripts/best-program.sh fd fdfind find)"

if test -n "${1-}"; then
  files=""
  extra_files=""
  for f in "${@}"; do
    test -f "${f}" || continue
    extension="${f##*.}"
    case "${extension}" in
      md)
        case "${f}" in
          .github/*) extra_files="${extra_files} ${f}"; continue;;
          *) ;;
        esac
        files="${files} ${f}";;
      *)
        continue
        ;;
    esac
  done
  if test -n "${extra_files}"; then
    mdl --rules "${extra_files_rules}" ${extra_files}
  fi
  test -n "${files}" || exit 0
  exec mdl ${files}
fi

case "${find_tool}" in
  fd|fdfind)
    files="$(${find_tool} . -H -E .github -t f -e md)"
    extra_files="$(${find_tool} . -H -t f -e md .github)"
    ;;
  find)
    files="$(find . -not -path './.github/*' -type f -name "*.md")"
    extra_files="$(find .github -type f -name "*.md")"
    ;;
  *) printf '%s\n' "Unsupported find tool" >&2; exit 1;;
esac

if test -n "${extra_files}"; then
  mdl --rules "${extra_files_rules}" ${extra_files}
fi
exec mdl ${files}
