#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
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
unwanted="$(printf '%s\n%s\n' "${ignored}" "${untracked}" |
  grep -e "^salt/\S\+/README.md" | cut -d "/" -f2 | sort -u)"
group="$(./scripts/spec-get.sh dom0 group)"
projects="$(find salt/ -mindepth 1 -maxdepth 1 -type d | sort -d |
  sed -e "s|^salt/\(\S\+\)|      - rpm_spec/${group}-\1.spec|")"
for unwanted_project in ${unwanted}; do
  projects="$(printf '%s\n' "${projects}" |
    sed -e "\@rpm_spec/${group}-${unwanted_project}.spec@d")"
done

if test "${1-}" = "print"; then
  printf '%s\n' "${projects}"
  exit 0
fi

sed -e "/@SPEC@/d" -- "${template}" | tee -- "${target}" >/dev/null
printf '%s\n' "${projects}" | tee -a -- "${target}" >/dev/null
if test "${1-}" = "test"; then
  if ! cmp -s -- "${target}" "${intended_target}"; then
    err_msg="${0##*/}: error: File ${intended_target} is not up to date"
    printf '%s\n' "${err_msg}" >&2
    err_msg="${0##*/}: error: Update the builder file with: ${0##/*}"
    printf '%s\n' "${err_msg}" >&2
    exit 1
  fi
fi
