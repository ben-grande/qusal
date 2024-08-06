#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later
##
## Finds Unicode recursively and prints in hexadecimal format.

set -eu

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel

files=""
if test -n "${1-}"; then
  files="${*}"
  if test -z "${files}"; then
    exit 0
  fi
fi

files="$(printf '%s\n' "${files}" | sort -u)"
# shellcheck disable=SC2086
unicode_match="$(grep -oPrHn --exclude-dir=.git --exclude-dir=LICENSES \
                  -e "[^\x00-\x7F]" -- ${files} || true)"

match_found=""
if test -n "${unicode_match}"; then
  for line in ${unicode_match}; do
    line_file="$(printf '%s\n' "${line}" | cut -d ":" -f1)"
    case "${line_file}" in
      git/*|LICENSES/*|.reuse/dep5|*.asc) continue;;
      *) ;;
    esac
    line_number="$(printf '%s\n' "${line}" | cut -d ":" -f2)"
    line_unicode="$(printf '%s\n' "${line}" | cut -d ":" -f3 | od -A n -vt c)"
    printf '%s\n' "${line_file}:${line_number}:${line_unicode}"
    match_found="1"
  done
  if test "${match_found}" = 1; then
    exit 1
  fi
fi

exit 0
