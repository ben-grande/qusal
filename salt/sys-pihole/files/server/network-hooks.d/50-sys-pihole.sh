#!/bin/sh

# SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
# SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

state="${1}"
vif="${2}"
vif_type="${3}"

nft -f /rw/config/qubes-firewall.d/50-sys-pihole

if test "${state}" = "online" && test "${vif_type}" = "vif"; then
  vif_localnet="/proc/sys/net/ipv4/conf/${vif}/route_localnet"
  if test -w "${vif_localnet}"; then
    printf '%s\n' 1 | tee -- "${vif_localnet}" >/dev/null
  fi
fi

if test -f /var/run/qubes-service/local-dns-server; then
  printf '%s\n' "nameserver 127.0.0.1" | tee -- /etc/resolv.conf >/dev/null
fi
