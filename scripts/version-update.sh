#!/bin/sh

## SPDX-FileCopyrightText: 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

usage(){
  printf '%s\n' "Usage: ${0##*/} TEMPLATE OLD_VERSION NEW_VERSION
Example: ${0##*/} fedora 41 42" >&2
  exit 1
}

case "${1-}" in
  ""|-h|--?help) usage;;
  *) ;;
esac

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel

template="${1}"
old_version="${2}"
new_version="${3}"

sed -i "s/${old_version}/${new_version}/" salt/"${template}"*/template.jinja
sed -i "s/${template}-${old_version}/${template}-${new_version}/" \
  salt/"${template}"*/README.md
