#!/bin/sh

## SPDX-FileCopyrightText: 2013-2018 Will Thames will@thames.id.au
## SPDX-FileCopyrightText: 2018 Ansible by Red Hat
## SPDX-FileCopyrightText: 2020 - 2023 Warpnet B.V.
## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

## Credits: https://salt-lint.readthedocs.io/en/latest/#fix-common-issues

# shellcheck disable=SC2086
set -eu

command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1

find_tool="find"
if command -v fd; then
  find_tool="fd"
elif command -v fdfind >/dev/null; then
  find_tool="fdfind"
fi

case "${find_tool}" in
  fd|fdfind) files="$(${find_tool} . minion.d/ --extension=conf) $(${find_tool} . salt/ --max-depth=2 --type=f --extension=sls)";;
  find) files="$(find minion.d/ -type f -name "*.conf") $(find salt/ -maxdepth 2 -type f -name '*.sls')";;
esac

## 201 - Fix trailing whitespace:
sed -i'' -e's/[[:space:]]*$//' ${files}

## 206 - Fix spacing around {{ var_name }}, eg. {{env}} --> {{ env }}:
sed -i'' -E "s/\{\{\s?([^}]*[^} ])\s?\}\}/\{\{ \1 \}\}/g" ${files}

## 207 - Add quotes around numeric values that start with a 0:
sed -i'' -E "s/\b(minute|hour): (0[0-7]?)\$/\1: '\2'/" ${files}

## 208 - Make dir_mode, file_mode and mode arguments in the desired syntax:
sed -i'' -E "s/\b(dir_|file_|)mode: 0?([0-7]{3})/\1mode: '0\2'/" ${files}
