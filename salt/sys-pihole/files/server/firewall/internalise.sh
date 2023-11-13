#!/bin/sh

# SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
# SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

for vif in /proc/sys/net/ipv4/conf/vif*; do
  test -d "${vif}" || continue
  test -f "${vif}/route_localnet" || continue
  test -w "${vif}/route_localnet" || continue
  echo 1 | tee "${vif}/route_localnet"
done
