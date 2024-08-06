#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

# shellcheck disable=3028
hostname="$(hostname)"
test "${hostname}" = "dom0" ||
  { printf '%s\n' "Must be run from dom0" >&2; exit 1; }
uid="$(id -u)"
test "${uid}" = "0" || exec sudo "${0}"

group="qusal"
file_roots="/srv/salt/${group}"

cd "${0%/*}"/..
## Avoid having extra unwanted files.
rm -rf -- "${file_roots}"
cp -f -- minion.d/*.conf /etc/salt/minion.d/
mkdir -p -- "${file_roots}"
cp -r -- salt/* "${file_roots}"
