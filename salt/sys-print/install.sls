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
    - setopt: "install_weak_deps=False"
    - pkgs:
      ## Discovery
      - cups
      - ipp-usb
      - man-db
      ## Print
      - system-config-printer
      ## Scan
      - simple-scan
      - sane-airscan

{% set pkg = {
    'Arch': {
      'pkg': [
        'cups-filters',
        'gnu-free-fonts',
        'gutenprint',
        'noto-fonts',
        'qubes-vm-networking',
        'ttf-dejavu',
        'ttf-liberation',
      ],
    },
    'Debian': {
      'pkg': [
        'cups-filters-core-drivers',
        'cups-ipp-utils',
        'fontconfig-config',
        'fonts-recommended',
        'printer-driver-cups-pdf',
        'printer-driver-gutenprint',
        'qubes-core-agent-networking',
        'sane',
        'sane-utils',
      ],
    },
    'RedHat': {
      'pkg': [
        'cups-filters-driverless',
        'cups-ipptool',
        'cups-pdf',
        'default-fonts',
        'gutenprint-cups',
        'liberation-fonts-all',
        'open-sans-fonts',
        'qubes-core-agent-networking',
        'sane-backends',
      ],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - setopt: "install_weak_deps=False"
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-add-user-to-lpadmin-group":
  group.present:
    - name: lpadmin
    - addusers:
      - user

"{{ slsdotpath }}-rpc":
  file.symlink:
    - name: /etc/qubes-rpc/qusal.Print
    - target: /dev/tcp/127.0.0.1/631
    - user: root
    - group: root
    - force: True
    - makedirs: True

"{{ slsdotpath }}-rpc-config":
  file.symlink:
    - name: /etc/qubes/rpc-config/qusal.Print
    - target: /etc/qubes/rpc-config/qubes.ConnectTCP
    - user: root
    - group: root
    - force: True
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
