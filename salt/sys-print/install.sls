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
      - man-db
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

"{{ slsdotpath }}-rpc":
  file.managed:
    - name: /etc/qubes-rpc/qusal.Print
    - source: salt://{{ slsdotpath }}/files/server/rpc/qusal.Print
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-bind-dirs":
  file.managed:
    - name: /etc/qubes-bind-dirs.d/50-sys-print.conf
    - source: salt://{{ slsdotpath }}/files/server/qubes-bind-dirs.d/50-sys-print.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
