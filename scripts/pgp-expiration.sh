#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

now="$(date +%s)"
fail="0"
for key in "${@}"; do
  data="$(gpg --no-keyring --no-auto-check-trustdb --no-autostart \
          --with-colons --show-keys "${key}")"
  nr="$(echo "${data}" | awk '/^(p|s)ub:/' | wc -l | cut -d " " -f1)"
  echo "${data}" | awk -v fail="0" -v key="${key}" -v nr="${nr}" \
    -v now="${now}" -F ':' '/^(p|s)ub:/ {
    nlines++;

    if ($7=="") {
      if (nlines==nr) { if (fail==1) { exit 1; }; }
      next
    }

    if ($7<now) {
      print key ": expired:", $5 >"/dev/stderr";
      fail=1
      if (nlines==nr) { if (fail==1) { exit 1; }; }
      next
    }

    # 60 days
    else if (($7-now)<(60*60*24*60)) {
      print key ": expires soon:", $5 >"/dev/stderr";
      fail=1
      if (nlines==nr) { if (fail==1) { exit 1; }; }
      next
    }

    if (fail==1) {
      exit 1
    }
  }' || fail="1"
done

if test "${fail}" = "1"; then
  exit 1
fi
