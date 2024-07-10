#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

command -v git >/dev/null || { echo "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
unset repo_toplevel

template=".qubesbuilder.template"
target=".qubesbuilder"
intended_target="${target}"
if test "${1-}" = "test"; then
  tmpdir="$(mktemp -d)"
  target="${tmpdir}/.qubesbuilder"
  # shellcheck disable=SC2154
  trap 'ec="$?"; rm -rf -- "${tmpdir}"; exit "${ec}"' EXIT INT HUP QUIT ABRT
fi
ignored="$(git ls-files --exclude-standard --others --ignored salt/)"
untracked="$(git ls-files --exclude-standard --others salt/)"
unwanted="$(printf %s"${ignored}\n${untracked}\n" |
  grep "^salt/\S\+/README.md" | cut -d "/" -f2 | sort -u)"
group="$(./scripts/spec-get.sh dom0 group)"
projects="$(find salt/ -mindepth 1 -maxdepth 1 -type d | sort -d |
  sed "s|^salt/\(\S\+\)|      - rpm_spec/${group}-\1.spec|")"
for unwanted_project in ${unwanted}; do
  projects="$(echo "${projects}" |
    sed "\@rpm_spec/${group}-${unwanted_project}.spec@d")"
done

if test "${1-}" = "print"; then
  echo "${projects}"
  exit 0
fi

sed -e "/@SPEC@/d" "${template}" | tee "${target}" >/dev/null
echo "${projects}" | tee -a "${target}" >/dev/null
if test "${1-}" = "test"; then
  if ! cmp -s "${target}" "${intended_target}"; then
    echo "${0##*/}: error: File ${intended_target} is not up to date" >&2
    echo "${0##*/}: error: Update the builder file with: ${0##/*}" >&2
    exit 1
  fi
fi
