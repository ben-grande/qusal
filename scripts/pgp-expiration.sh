#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

now="$(date +%s)"
fail="0"
for key in "${@}"; do
  ## TODO: exit only after evaluating all subkeys, not on the first error.
  gpg --no-keyring --no-auto-check-trustdb --no-autostart \
  --with-colons --show-keys "${key}" |
  awk -v key="${key}" -v now="${now}" -F ':' '/^(p|s)ub:/ {
    if ($7=="") {
      next
    }
    if ($7<now) {
        print key ": expired:", $5 >"/dev/stderr";
        exit 1
    }
    # 60 days
    else if (($7-now)<(60*60*24*60)) {
        print key ": expires soon:", $5 >"/dev/stderr";
        exit 1
    }
  }' || fail="1"
done

if test "${fail}" = "1"; then
  exit 1
fi
