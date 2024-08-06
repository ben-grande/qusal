#!/bin/sh
## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

requires_program=""
for pkg in "${@}"; do
  if ! command -v "${pkg}" >/dev/null; then
    requires_program="${requires_program:+"${requires_program} "}${pkg}"
    continue
  fi
done

if test -n "${requires_program}"; then
  printf '%s\n' "Missing program(s): ${requires_program}" >&2
  exit 1
fi
