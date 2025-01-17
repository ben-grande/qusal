#!/bin/sh

## SPDX-FileCopyrightText: 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

## Try its best to get wrong copyright information.
## Will show false positives if the copyright owner uploads code with year
## smaller than the current year.

set -eu

if test -n "${GITHUB_ACTION:-}"; then
  exit 0
fi

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel
./scripts/requires-program.sh reuse date

case "${-}" in
  *x*) xtrace=1;;
  *) xtrace=0;;
esac

email="<${GIT_EMAIL:-"$(git config --get user.email)"}>"
year="$(date -- '+%Y')"
fail="0"

files=""
if test -n "${1-}"; then
  for f in "${@}"; do
    test -f "${f}" || continue
    test -r "${f}" || continue
    files="${files} ${f}"
  done
else
  files="$(git log --name-only --date=raw --since="${year}" --format="")"
  files="${files} $(git diff --cached --name-only)"
fi

if test -z "${files}"; then
  exit 0
fi

tmpdir="$(mktemp -d)"
target="${tmpdir}/spdx"
trap 'rm -rf -- "${tmpdir}"' EXIT INT HUP QUIT ABRT

set +x
data="$(reuse spdx)"
printf '%s\n' "${data}" | tee -- "${target}"  >/dev/null
test "${xtrace}" = 0 || set -x

for file in ${files}; do
  test "${xtrace}" = 0 || set -x
  case "${file}" in
    .reuse/dep5) continue;;
    *) ;;
  esac
  file="${file#./}"
  set +x
  awk -v year="${year}" -v email="${email}" -v file="${file}" -- '
  BEGIN {
    year_found = 0
  }

  $1 == "FileName:" {
    sub(/^\.\//, "", $2)
    f = ($2 == file)
  }

  ($1 == "FileCopyrightText:" || $1 == "SPDX-FileCopyrightText:") && f {
    sub(/^(SPDX-)?FileCopyrightText:\s<text>SPDX-FileCopyrightText:\s/, "")
    sub(/^SPDX-FileCopyrightText:\s/, "")
    sub(/^FileCopyrightText:\s<text>/, "")
    sub(/<\/text>$/, "")
    if ($NF == email) {
      found_years = $0
      gsub(/[^0-9,-]/, "", found_years)
      split(found_years, year_array, "[-,]")
      for (i in year_array) {
        if (year_array[i] + 0 >= year) {
          year_found = 1
          break
        }
      }
    }
  }

  END {
    if (year_found != 1) {
      message = file ": " found_years ": outdated copyright year: " email
      print message > "/dev/stderr"
      exit 1
    }
  }' "${target}" || fail=1
done

if test "${fail}" = "1"; then
  exit 1
fi
