#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC2086
set -eu

command -v git >/dev/null || { echo "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
unset repo_toplevel
./scripts/requires-program.sh salt-lint

find_tool="$(./scripts/best-program.sh fd fdfind find)"
possible_conf="${PWD}/.salt-lint.yaml"
conf=""
test -f "${possible_conf}" && conf="-c ${possible_conf}"

if test -n "${1-}"; then
  files=""
  for f in "${@}"; do
    test -f "${f}" || continue
    extension="${f##*.}"
    case "${extension}" in
      top|sls) files="${files} ${f}";;
      *) continue;;
    esac
  done
  test -n "${files}" || exit 0
  exec salt-lint ${conf} ${files}
fi

case "${find_tool}" in
  fd|fdfind)
    conf_files="$(${find_tool} . minion.d/ -e conf)"
    sls_files="$(${find_tool} . salt/ -d 2 -t f -e sls -e top | sort -d)"
    files="${conf_files}\n${sls_files}"
    ;;
  find)
    conf_files="$(find minion.d/ -type f -name "*.conf")"
    sls_files="$(find salt/* -maxdepth 2 -type f \
      \( -name '*.sls' -o -name '*.top' \) | sort -d)"
    files="${conf_files}\n${sls_files}"
    ;;
  *) echo "Unsupported find tool" >&2; exit 1;;
esac

exec salt-lint ${conf} ${files}
