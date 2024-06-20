#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC2034
set -eu

usage(){
  names="$(find salt/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
           | sort -d | tr "\n" " ")"
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

keys="name branch group file_roots requires packager vendor url bug_url version project project_dir changelog readme license_csv license description summary saltfiles"

name=""
key=""
case "${1-}" in
  "") usage; exit 1;;
  -h|--?help) usage; exit 0;;
  *) name="${1}"; shift;;
esac
case "${1-}" in
  "") usage; exit 1;;
  *) key="${1}"; shift;;
esac
if test -z "${key##* }"; then
  echo "Key is emtpy: ${key}" >&2
  exit 1
fi

command -v git >/dev/null || { echo "Missing program: git" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1
./scripts/requires-program.sh reuse

if test "${key}" = "branch"; then
  branch="$(git branch --show-current)"
fi

group="qusal"
block_max_chars group "${group}" 70
file_roots="/srv/salt/${group}"
vendor="${QUSAL_VENDOR:-"Benjamin Grande"}"
packager="${QUSAL_PACKAGER:-"Benjamin Grande"}"
url="${QUSAL_URL:-"https://github.com/ben-grande/qusal"}"
bug_url="${QUSAL_BUGURL:-"https://github.com/ben-grande/qusal/issues"}"
# shellcheck disable=SC2094
read -r version <version

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

if test "${key}" = "license" || test "${key}" = "license_csv"; then
  license_csv="$(reuse --root "${project_dir}" lint |
    awk -F ':' '/^* Used licenses:/{print $2}' | tr -d " ")"
  license="$(echo "${license_csv}" | sed "s/,/ AND /g")"
fi

## The macro %autochangelog prints logs of all projects and we separate a
## project per directory. The disadvantage of the changelog below is it
# #doesn't differentiate commits per version and release, but per commit id.
if test "${key}" = "changelog"; then
  changelog="$(TZ=UTC0 git log -n 50 --format=format:"* %cd %an <%ae> - %h%n- %s%n" --date=format:"%a %b %d %Y" -- "${project_dir}" | sed -re "s/^- +- */- /")"
fi

if test "${key}" = "description"; then
  description="$(sed -n '/^## Description/,/^## /p' -- "${readme}" |
                sed '1d;$d' | sed "1{/^$/d}")"
fi

if test "${key}" = "summary"; then
  summary="$(sed -n "/^# ${name}$/,/^## Table of Contents$/{
                     /./!d; /^#/d; s/\.$//; p}" -- "${readme}")"
  block_max_chars summary "${summary}" 70
fi

if test "${key}" = "saltfiles" || test "${key}" = "requires"; then
  saltfiles="$(find "${project_dir}" -maxdepth 1 -name "*.sls")"
  # shellcheck disable=SC2086
  if test -n "${saltfiles}"; then
    requires="$(sed -n '/^include:$/,/^\s*$/p' -- ${saltfiles} | sed "/^\s*- \./d;/{/d" | grep "^\s*- " | cut -d "." -f1 | sort -u | sed "s/- //")"
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
  bug_url) echo "${bug_url}";;
  vendor) echo "${vendor}";;
  packager) echo "${packager}";;
  version) echo "${version}";;
esac
