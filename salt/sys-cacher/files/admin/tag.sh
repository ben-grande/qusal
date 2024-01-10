#!/bin/sh

# SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

exclude="$(qvm-ls --no-spinner --raw-list --tags whonix-updatevm \
           | sed "s/^./--exclude &/" | tr "\n" " ")"

# shellcheck disable=SC2086
wanted="$(qvm-ls --no-spinner --raw-data --fields=NAME,CLASS --all ${exclude} \
          | awk -v class="TemplateVM" -F "|" '$2 ~ class {print $1}')"

echo "${wanted}"
