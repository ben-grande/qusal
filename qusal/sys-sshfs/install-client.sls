{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated-client":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-client":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - socat

{% set pkg = {
    'Debian': {
      'pkg': ['sshfs', 'openssh-client'],
    },
    'RedHat': {
      'pkg': ['fuse-sshfs', 'openssh-clients'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-client-os-specific":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
