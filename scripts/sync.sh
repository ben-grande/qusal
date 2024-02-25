#!/bin/sh

## SPDX-FileCopyrightText: 2024 PeakUnshift <peakunshift@intellectual.rehab>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

test "$(hostname)" = "dom0" || { echo "Must be run from dom0" >&2; exit 1; }
test "$(id -u)" = "0" || exec sudo "${0}"

qube="CHANGEME" # qube name where you downloaded the repository
file="CHANGEME" # path to the repository in the qube
rm -rfi ~/QubesIncoming/"${qube}"/qusal
UPDATES_MAX_FILES=10000 qvm-copy-to-dom0 "${qube}" "${file}"
