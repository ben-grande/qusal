#!/bin/sh

# SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

nft -f /rw/config/qubes-firewall.d/50-sys-pihole

for vif in /proc/sys/net/ipv4/conf/vif*/route_localnet; do
  test -w "${vif}" || continue
  echo 1 | tee -- "${vif}" >/dev/null
done

if test -f /var/run/qubes-service/local-dns-server; then
  printf '%s\n' "nameserver 127.0.0.1" | tee -- /etc/resolv.conf >/dev/null
fi
