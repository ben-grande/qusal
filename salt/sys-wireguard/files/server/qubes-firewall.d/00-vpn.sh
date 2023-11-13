#!/bin/sh

# SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

echo "define qubes_ip = $(qubesdb-read /qubes-ip)" \
  | tee /rw/config/vpn/qubes-ip.nft >/dev/null

nft -f /rw/config/vpn/dns-hijack.nft

## TODO: read https://www.wireguard.com/netns/
