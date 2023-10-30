#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: GPL-3.0-or-later

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

case "${find_tool}" in
  fd|fdfind) files="minion.d/qusal.conf $(${find_tool} . qusal/ --max-depth=1 --type=f --extension=sls --extension=top)";;
  find) files="minion.d/qusal.conf $(find qusal/* -maxdepth 1 -type f \( -name '*.sls' -o -name '*.top' \))";;
esac

salt-lint ${conf} ${files}
