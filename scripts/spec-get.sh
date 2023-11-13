#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC2034
set -eu

usage(){
  names="$(find salt/ -maxdepth 1 -type d | cut -d "/" -f2 | tr "\n" " ")"
  echo "Usage: ${0##*/} <NAME> <KEY>"
  echo "Example: ${0##*/} qubes-builder description"
  echo "Names: ${names}"
  echo "Keys: ${keys}"
}

block_max_chars(){
  char_key="${1}"
  char_value="${2}"
  less_than="${3}"
  if test "${#char_value}" -ge "${less_than}"; then
    echo "Error: ${char_key} is too long. Must be less than ${less_than} chars." >&2
    echo "Key contents: ${char_value}" >&2
    exit 1
  fi
}

keys="name branch group file_roots requires vendor url version project project_dir changelog readme license_csv license description summary saltfiles"

case "${1-}" in
  "") usage; exit 1;;
  -h|--?help) usage; exit 0;;
esac
case "${2-}" in
  "") usage; exit 1;;
esac

command -v reuse >/dev/null ||
  { printf "Missing program: reuse\n" >&2; exit 1; }
command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1

name="${1}"
key="${2}"
branch="$(git branch --show-current)"
group="qusal"
block_max_chars group "${group}" 70

file_roots="/srv/salt/${group}"
vendor="Benjamin Grande"

url="https://github.com/ben-grande/qusal"
version="1.0"

project="${group}-${name}"
project_dir="salt/${name}"

if ! test -d "${project_dir}"; then
  echo "Project doesn't exist: ${project_dir}" >&2
  exit 1
fi

readme="${project_dir}/README.md"
if ! test -f "${readme}"; then
  echo "Project ${name} does not have README.md" >&2
  exit 1
fi

license_csv="$(reuse --root "${project_dir}" lint |
  awk -F ':' '/^* Used licenses:/{print $2}' | tr -d " ")"
license="$(echo "$license_csv" | sed "s/,/ AND /g")"
#license="$(reuse --root "${project_dir}" lint |
#           awk -F ':' '/^* Used licenses:/{print $2}' | sed "s|, | AND |g")"

## The problem with %autochangelog is that it will print logs of all projects
## and we separate a project per directory.
## The disadvantage of the changelog below is that it doesn't differentiate
## commits per package release.
changelog="$(TZ=UTC0 git log -n 50 --format=format:"* %cd %an <%ae> - %h%n- %s%n%n" --date=format:"%a %b %d %Y" -- "${project_dir}" | sed -re "s/^- +- */- /;/^$/d")"

#block_max_chars license "${license}" 70
description="$(sed -n '/^## Description/,/^## /p' "${readme}" |
               sed '1d;$d' | sed "1{/^$/d}")"
summary="$(sed -n '3p' "${readme}")"
block_max_chars summary "${summary}" 70

saltfiles="$(find "${project_dir}" -maxdepth 1 -name "*.sls")"
# shellcheck disable=SC2086
if test -n "${saltfiles}"; then
  requires="$(sed -n '/^include:$/,/^\s*$/p' ${saltfiles} | sed "/^\s*- \./d;/{/d" | grep "^\s*- " | cut -d "." -f1 | sort -u | sed "s/- //")"
  if grep -qrn "{%-\? from \('\|\"\)utils" ${saltfiles}; then
    if test -n "${requires}"; then
      requires="${requires} utils"
    else
      requires="utils"
    fi
  fi
else
  requires=""
fi
requires_valid=""
for r in $(printf %s"${requires}" | tr " " "\n"); do
  if ! test -d "salt/${r}"; then
    continue
  fi
  requires_valid="${requires_valid} ${r}"
done
requires="${requires_valid}"
unset requires_valid

if test -z "${key}" || test "$(echo "${key}" | sed "s/ //g")" = ""; then
  echo "Key has no value: ${key}" >&2
  exit 1
fi

case "${key}" in
  "") exit 1;;
  branch) echo "${branch}";;
  changelog) echo "${changelog}";;
  description) echo "${description}";;
  file_roots) echo "${file_roots}";;
  group) echo "${group}";;
  license_csv) echo "${license_csv}";;
  license) echo "${license}";;
  name) echo "${name}";;
  project) echo "${project}";;
  project_dir) echo "${project_dir}";;
  readme) echo "${readme}";;
  requires) echo "${requires}";;
  saltfiles) echo "${saltfiles}";;
  summary) echo "${summary}";;
  url) echo "${url}";;
  vendor) echo "${vendor}";;
  version) echo "${version}";;
esac
