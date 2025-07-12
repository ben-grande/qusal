{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - sys-print.install

{% set pkg = {
    'Arch': {
      'pkg': [
        'foomatic-db-gutenprint-ppds',
      ],
    },
    'Debian': {
      'pkg': [
        'printer-driver-all-enforce',
      ],
    },
    'RedHat': {
      'pkg': [
        'c2esp',
        'dymo-cups-drivers',
        'epson-inkjet-printer-escpr',
        'epson-inkjet-printer-escpr2',
        'foomatic',
        'foomatic-db',
        'foomatic-db-ppds',
        'printer-driver-brlaser',
        'ptouch-driver',
      ],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-driver-all":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}
{% endif -%}
