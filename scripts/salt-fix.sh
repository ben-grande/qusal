#!/bin/sh

## SPDX-FileCopyrightText: 2013 - 2018 Will Thames will@thames.id.au
## SPDX-FileCopyrightText: 2018 Ansible by Red Hat
## SPDX-FileCopyrightText: 2020 - 2023 Warpnet B.V.
## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

## Credits: https://salt-lint.readthedocs.io/en/latest/#fix-common-issues

# shellcheck disable=SC2086
set -eu

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel

find_tool="$(./scripts/best-program.sh fd fdfind find)"

case "${find_tool}" in
  fd|fdfind)
    conf_files="$(${find_tool} . minion.d/ -e conf)"
    sls_files="$(${find_tool} . salt/ -d 2 -t f -e sls)"
    set -- ${conf_files} ${sls_files}
    ;;
  find)
    conf_files="$(find minion.d/ -type f -name "*.conf")"
    sls_files="$(find salt/ -maxdepth 2 -type f -name '*.sls')"
    set -- ${conf_files} ${sls_files}
    ;;
  *) printf '%s\n' "Unsupported find tool" >&2; exit 1;;
esac

## 201 - Fix trailing whitespace:
sed -i'' -e 's/[[:space:]]*$//' -- "${@}"

## 206 - Fix spacing around {{ var_name }}, eg. {{env}} --> {{ env }}:
sed -i'' -E -e "s/\{\{\s?([^}]*[^} ])\s?\}\}/\{\{ \1 \}\}/g" -- "${@}"

## 207 - Add quotes around numeric values that start with a 0:
sed -i'' -E -e "s/\b(minute|hour): (0[0-7]?)\$/\1: '\2'/" -- "${@}"

## 208 - Make dir_mode, file_mode and mode arguments in the desired syntax:
sed -i'' -E -e "s/\b(dir_|file_|)mode: 0?([0-7]{3})/\1mode: '0\2'/" -- "${@}"
