#!/bin/sh
## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

current_dpi="$(xrdb -get Xft.dpi)"
wanted_dpi="144"

if test -z "${current_dpi}" || test "${current_dpi}" -lt "${wanted_dpi}"
then
  printf '%s\n' "Xft.dpi: ${wanted_dpi}" | xrdb -override -
fi
