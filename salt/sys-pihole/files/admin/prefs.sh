#!/bin/sh

# SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

## Change the netvm of every qube that has (disp-)sys-firewall to pihole.
for qube in $(qvm-ls --raw-data --fields=NAME,NETVM |
              awk -F '|' '/\|(disp-)?sys-firewall$/{print $1}')
do
  ## Avoid overwriting netvm to sys-pihole when instead it should use the
  ## default_netvm, so better to prevent overwriting user choices.
  qvm-prefs "${qube}" | grep -q -e "^netvm[[:space:]]\+D" && continue
  ## Set netvm for qubes that were using (disp-)sys-firewall to sys-pihole.
  qvm-prefs "${qube}" netvm sys-pihole
done

exit 0
