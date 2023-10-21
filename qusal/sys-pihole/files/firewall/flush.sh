#!/bin/sh

# SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
# SPDX-FileCopyrightText: 2023 Qusal contributors
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -eu

nft -f /rw/config/network-hooks.d/flush
