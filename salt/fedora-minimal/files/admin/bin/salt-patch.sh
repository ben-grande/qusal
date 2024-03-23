#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

## TODO: Remove when template with patch reaches upstream or updates enforce
## salt-deps to be installed.
## https://github.com/QubesOS/qubes-issues/issues/8806

set -eu

qube="${1}"
qvm-run --user=root --pass-io --filter-escape-chars --no-color-output \
  --no-color-stderr "${qube}" -- \
  "dnf --quiet install --refresh --assumeyes --setopt=install_weak_deps=False python3-urllib3"
