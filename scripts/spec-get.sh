#!/bin/sh

## SPDX-FileCopyrightText: 2023 Qusal contributors
##
## SPDX-License-Identifier: GPL-3.0-or-later

# shellcheck disable=SC2034
set -eu

usage(){
  names="$(find qusal -maxdepth 1 -type d | cut -d "/" -f2 | tr "\n" " ")"
  echo "Usage: ${0##*/} NAME KEY"
  echo "Example: ${0##*/} qubes-builder description"
  echo "Names: ${names}"
  echo "Keys: ${keys}"
}

block_max_chars(){
  char_key="${1}"
  char_key_expanded="$(eval echo '$'"${char_key}")"
  less_than="${2}"
  if test "${#char_key_expanded}" -ge "${less_than}"; then
    echo "Error: ${char_key} is too long. Must be less than ${less_than} chars." >&2
    echo "Key contents: ${char_key_expanded}" >&2
    exit 1
  fi
}

keys="name branch group file_root vendor url version project project_dir changelog readme license description summary saltfiles"

case "${1-}" in
  "") usage; exit 1;;
  -h|--?help) usage; exit 0;;
esac
case "${2-}" in
  "") usage; exit 1;;
esac

command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1

name="${1}"
key="${2}"
branch="$(git branch --show-current)"
group="qusal"
block_max_chars group 70
file_roots="/srv/salt/${group}"
vendor="Benjamin Grande"
license="GPL-3.0-or-later"


url="https://github.com/ben-grande/qusal"
version="1.0"

project="${group}-${name}"
project_dir="${group}/${name}"
changelog="$(TZ=UTC0 git log -n 50 --format=format:"* %cd %an <%ae> - %h%n- %s%n%n" --date=format:"%a %b %d %Y" -- "${project_dir}" | sed -re "s/^- +- */- /;/^$/d")"
readme="${project_dir}/README.md"
if ! test -f "${readme}"; then
  echo "Project ${name} does not have README.md" >&2
  exit 1
fi

block_max_chars license 70
description="$(sed -n '/^## Description/,/^## /p' "${readme}" |
               sed '1d;$d' | sed "1{/^$/d}")"
summary="$(echo "${description}" | sed "/^$/d" | head -1)"
block_max_chars summary 70

saltfiles="$(find "${project_dir}" -maxdepth 1 -name "*.sls")"
# shellcheck disable=SC2086
if test -n "${saltfiles}"; then
  requires="$(sed -n '/^include:$/,/^\s*$/p' ${saltfiles} | sed "/^\s*- \./d;/{/d" | grep "^\s*- " | cut -d "." -f1 | sort -u | sed "s/- //")"
else
  requires=""
fi
requires_valid=""
for r in $(printf %s"${requires}" | tr " " "\n"); do
  if ! test -d "${group}/${r}"; then
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

## Not evaluating variables if it contains '*'.
case "${key}" in
  "") exit 1;;
  description) echo "${description}";;
  changelog) echo "${changelog}";;
  *) eval echo "$""${key}";;
esac
