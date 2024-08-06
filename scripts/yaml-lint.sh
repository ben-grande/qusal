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
./scripts/requires-program.sh yamllint

if test -n "${1-}"; then
  files=""
  for f in "${@}"; do
    test -f "${f}" || continue
    extension="${f##*.}"
    case "${extension}" in
      yaml|yml) files="${files} ${f}";;
      *) continue;;
    esac
  done
  test -n "${files}" || exit 0
  exec yamllint ${files}
fi

exec yamllint .
