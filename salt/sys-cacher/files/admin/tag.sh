#!/bin/sh

# SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

exclude="$(qvm-ls --no-spinner --raw-list --tags whonix-updatevm \
           | sed "s/^./--exclude &/" | tr "\n" " ")"

# shellcheck disable=SC2086
templates="$(qvm-ls --no-spinner --raw-data --fields=NAME,CLASS --all ${exclude} \
             | awk -v class="TemplateVM" -F "|" '$2 ~ class {print $1}' \
             | tr "\n" " ")"

wanted=""
for qube in ${templates}; do
  os_distro="$(qvm-features "${qube}" os-distribution || true)"
  case "${os_distro}" in
    debian|kali|kicksecure|parrot| \
    ubuntu|linuxmint| \
    arch|blackarch| \
    fedora)
      wanted="${wanted:+"${wanted} "}${qube}"
      ;;
    *) continue
  esac
done

echo "${wanted}" | tr " " "\n"
