{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-x11
  - sys-usb.install-client

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      ## Discovery
      - qubes-core-agent-networking
      - cups
      - ipp-usb
      ## Print
      - printer-driver-cups-pdf
      - system-config-printer
      ## Scan
      ## TODO: simple-scan did not detect my scanner, but detected printer.
      - simple-scan
      - sane
      - sane-utils
      - sane-airscan

"{{ slsdotpath }}-add-user-to-lpadmin-group":
  group.present:
    - name: lpadmin
    - addusers:
      - user

{% endif -%}
