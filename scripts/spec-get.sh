#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC2034
set -eu

usage(){
  names="$(find salt/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
            | sort -d | tr "\n" " ")"
  keys_trimmed="$(printf '%s\n' "${keys}" | tr "\n" " ")"
  printf '%s\n' "Usage: ${0##*/} <NAME> <KEY>"
  printf '%s\n' "Example: ${0##*/} qubes-builder description"
  printf '%s\n' "Names: ${names}"
  printf '%s\n' "Keys: ${keys_trimmed}"
}

block_max_chars(){
  char_key="${1}"
  char_value="${2}"
  less_than="${3}"
  if test "${#char_value}" -ge "${less_than}"; then
    err_msg="error: ${char_key} is too long. Must be <${less_than} chars."
    printf '%s\n' "${err_msg}" >&2
    printf '%s\n' "Key contents: ${char_value}" >&2
    exit 1
  fi
}

keys="name
branch
group
file_roots
requires
packager
vendor
url
bug_url
version
project
project_dir
changelog
readme
license_csv
license
description
summary
saltfiles"

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
  printf '%s\n' "Key was not given" >&2
  exit 1
fi

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel
./scripts/requires-program.sh reuse

if test "${key}" = "branch"; then
  branch="$(git branch --show-current)"
fi

toplevel="$(git rev-parse --show-toplevel)"
group="${toplevel##*/}"
block_max_chars group "${group}" 70
file_roots="/srv/salt/${group}"
vendor="${SPEC_VENDOR:-"$(git config --get user.name)"}"
packager="${SPEC_PACKAGER:-"${vendor} <$(git config --get user.email)>"}"
url="${SPEC_URL:-"https://github.com/ben-grande/qusal"}"
bug_url="${SPEC_BUGURL:-"${url}/issues"}"

if test -z "${group}" || test -z "${vendor}" || test -z "${packager}" \
  || test -z "${url}" || test -z "${bug_url}"
then
  err_msg="At least one empty var: group, vendor, packager, url, bug_url"
  printf '%s\n' "${err_msg}" >&2
  exit 1
fi


project="${group}-${name}"
project_dir="salt/${name}"

if ! test -d "${project_dir}"; then
  printf '%s\n' "Project doesn't exist: ${project_dir}" >&2
  exit 1
fi

# shellcheck disable=SC2094
read -r version <"${project_dir}/version"
readme="${project_dir}/README.md"
if ! test -f "${readme}"; then
  printf '%s\n' "Project ${name} does not have README.md" >&2
  exit 1
fi

if test "${key}" = "license" || test "${key}" = "license_csv"; then
  license_csv="$(reuse --root "${project_dir}" lint |
    awk -F ':' '/^\* Used licenses:/{print $2}' | tr " " "\n" | tr -d "," |
    sort -d | tr -s "\n" "," | sed "s/^\,//;s/\,$//")"
  license="$(printf '%s\n' "${license_csv}" | sed "s/\,/ AND /g")"
fi

## The macro %autochangelog prints logs of all projects and we separate a
## project per directory. The disadvantage of the changelog below is it
# #doesn't differentiate commits per version and release, but per commit id.
if test "${key}" = "changelog"; then
  changelog="$(TZ=UTC0 git log -n 50 \
    --format=format:"* %cd %an <%ae> - %h%n- %s%n" \
    --date=format:"%a %b %d %Y" -- "${project_dir}" | \
    sed -re "s/^- +- */- /")"
fi

if test "${key}" = "description"; then
  description="$(sed -n '/^## Description/,/^## /p' -- "${readme}" |
                sed '1d;$d' | sed "1{/^$/d}")"
fi

if test "${key}" = "summary"; then
  summary="$(sed -n -e \
              "/^# ${name}$/,/^## Table of Contents$/{
              /^$/d; /^#/d; /^SPDX/d; /^<!--/d; /^-->/d; s/\.$//; p}" \
              -- "${readme}")"
  block_max_chars summary "${summary}" 70
fi

if test "${key}" = "saltfiles" || test "${key}" = "requires"; then
  saltfiles="$(find "${project_dir}" -maxdepth 1 -name "*.sls")"
  # shellcheck disable=SC2086
  if test -n "${saltfiles}"; then
    requires="$(sed -n -e '/^include:$/,/^\s*$/p' -- ${saltfiles} |
      sed -e "/^\s*- \./d;/{/d" | grep -e "^\s*- " | cut -d "." -f1 |
      sort -u | sed -e "s/- //")"
    if grep -qrn -e "{%-\? from \('\|\"\)utils" ${saltfiles}; then
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
  for r in $(printf '%s' "${requires}" | tr " " "\n"); do
    if ! test -d "salt/${r}"; then
      continue
    fi
    requires_valid="${requires_valid} ${r}"
  done
  requires="${requires_valid}"
  unset requires_valid
fi

case "${key}" in
  branch) printf '%s\n' "${branch}";;
  changelog) printf '%s\n' "${changelog}";;
  description) printf '%s\n' "${description}";;
  file_roots) printf '%s\n' "${file_roots}";;
  group) printf '%s\n' "${group}";;
  license_csv) printf '%s\n' "${license_csv}";;
  license) printf '%s\n' "${license}";;
  name) printf '%s\n' "${name}";;
  project) printf '%s\n' "${project}";;
  project_dir) printf '%s\n' "${project_dir}";;
  readme) printf '%s\n' "${readme}";;
  requires) printf '%s\n' "${requires}";;
  saltfiles) printf '%s\n' "${saltfiles}";;
  summary) printf '%s\n' "${summary}";;
  url) printf '%s\n' "${url}";;
  bug_url) printf '%s\n' "${bug_url}";;
  vendor) printf '%s\n' "${vendor}";;
  packager) printf '%s\n' "${packager}";;
  version) printf '%s\n' "${version}";;
  "") exit 1;;
  *) printf '%s\n' "Unsupported key" >&2; exit 1;;
esac
