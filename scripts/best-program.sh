#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC2086
set -eu

command -v git >/dev/null || { echo "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
unset repo_toplevel

for tool in "${@}"; do
  if ./scripts/requires-program.sh "${tool}" >/dev/null 2>&1; then
    echo "${tool}"
    break
  fi
done
