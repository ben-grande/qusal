#!/bin/sh
## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

missing_program=0
for pkg in "${@}"; do
  if ! command -v "${pkg}" >/dev/null; then
    missing_program=1
    echo "Missing program: ${pkg}" >&2
    continue
  fi
done

if test "${missing_program}" = "1"; then
  exit 1
fi
