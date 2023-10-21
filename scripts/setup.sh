#!/bin/sh

## SPDX-FileCopyrightText: 2023 Qusal contributors
##
## SPDX-License-Identifier: GPL-3.0-or-later

set -eu

test "$(hostname)" = "dom0" || { echo "Must be run from dom0" >&2; exit 1; }
test "$(id -u)" = "0" || exec sudo "${0}"

group="qusal"
file_roots="/srv/salt/${group}"

## Avoid having extra unwanted files.
rm -rf "${file_roots}"
cp -f minion.d/"${group}".conf /etc/salt/minion.d/
mkdir -p "${file_roots}"
cp -r "${group}"/* "${file_roots}"
