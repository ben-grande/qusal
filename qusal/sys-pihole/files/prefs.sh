#!/bin/sh

# SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
# SPDX-FileCopyrightText: 2023 Qusal contributors
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -eu

qvm-start --skip-if-running sys-pihole && sleep 5

if qubes-prefs updatevm | grep -q sys-firewall; then
  qubes-prefs updatevm sys-pihole
fi

if qubes-prefs default_netvm | grep -q sys-firewall; then
  qubes-prefs default_netvm sys-pihole
fi

for qube in $(qvm-ls --raw-data --fields=NAME,NETVM |
            awk -F '|' '/sys-firewall$/{print  $1}')
do
  ## Avoid overwriting netvm to sys-pihole when instead it should use the
  ## default_netvm, so better to prevent overwriting user choices.
  qvm-prefs "$qube" | grep -q "^netvm[[:space:]]\+D" && continue
  ## Set netvm for qubes that were using sys-firewall to sys-pihole.
  qvm-prefs "$qube" netvm sys-pihole
done

exit 0