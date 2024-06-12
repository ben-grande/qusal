#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

command -v git >/dev/null || { echo "Missing program: git" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1

./scripts/qubesbuilder-gen.sh
./scripts/spec-build.sh
./scripts/yumrepo-gen.sh
