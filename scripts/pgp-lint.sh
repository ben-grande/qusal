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

now="$(date -- +%s)"
fail="0"
find_tool="$(./scripts/best-program.sh fd fdfind find)"

if test -n "${1-}"; then
  files=""
  for f in "${@}"; do
    test -f "${f}" || continue
    test -r "${f}" || continue
    extension="${f##*.}"
    case "${extension}" in
      asc|gpg) files="${files} ${f}";;
      *) continue;;
    esac
  done
else
  case "${find_tool}" in
    fd|fdfind)
      files="$(${find_tool} . -H -t f -e asc -e gpg | sort -d)"
      ;;
    find)
      files="$(find . -type f \( -name '*.asc' -o -name '*.gpg' \) | sort -d)"
      ;;
    *) printf '%s\n' "Unsupported find tool" >&2; exit 1;;
  esac
fi

if test -z "${files}"; then
  exit 0
fi

for key in ${files}; do
  data="$(gpg --no-keyring --no-auto-check-trustdb --no-autostart \
    --with-colons --show-keys "${key}")"
  nr="$(printf '%s\n' "${data}" | grep -Ec -e '^(p|s)ub:')"
  ## Threshold in days.
  threshold="${PGP_LINT_THRESHOLD:-30}"
  tty_stderr=0
  if test -t 2; then
    tty_stderr=1
  fi
  printf '%s\n' "${data}" | awk -v fail="0" -v key="${key}" -v nr="${nr}" \
    -v threshold="${threshold}" -v now="${now}" -v color="${tty_stderr}" \
    -F ':' '
    BEGIN {
      MAGENTA = ""
      YELLOW = ""
      RED = ""
      RESET = ""
      if (color == 1) {
        MAGENTA = "\033[1;35m"
        YELLOW = "\033[1;33m"
        RED = "\033[1;31m"
        RESET = "\033[0m"
      }
    }

    /^(p|s)ub:/{

      nlines++

      if ($7 == "") {
        if (nlines == nr ) { if (fail == 1) { exit 1 } }
        next
      }

      if ($7 < now) {
        message = MAGENTA key RESET ":" RED " expired" RESET ": " $5
        print message >"/dev/stderr"
        fail = 1
        if (nlines == nr ) { if (fail == 1) { exit 1 } }
        next
      }

      else if (($7 - now) < (60 * 60 * 24 * threshold )) {
        remaining_days = int(($7 - now) / (60 * 60 * 24))
        message_prefix = MAGENTA key RESET ":" YELLOW " expires in "
        message_suffix = remaining_days " days" RESET ": " $5
        message = message_prefix message_suffix
        print message >"/dev/stderr"
        fail = 1
        if (nlines == nr ) { if (fail == 1) { exit 1 } }
        next
      }

      if (fail == 1) {
        exit 1
      }
    }' || fail="1"
done

if test "${fail}" = "1"; then
  exit 1
fi
