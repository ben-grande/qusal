#!/bin/sh

# SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
# SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

target_file="/home/user/wireguard.conf"

if ! zenity --question \
  --text="Please select the wireguard configuration file you want to use" \
  --ok-label="OK" --cancel-label="No"
then
  zenity --error --text="You need a config file\nCheck with Mullvad VPN"
  exit 1
fi

client_file="$(zenity --file-selection)"

if test -z "${client_file}"; then
  zenity --error --text="No file selected"
  exit 1
fi

if ! grep -q '^PrivateKey' "$client_file" ; then
  zenity --error --text="That doesn't look like a client config file"
  exit 1
fi

test "$client_file" != "$target_file" && cp "$client_file" "$target_file"
zenity --info --text="Restart this qube. The VPN service will autostart"
