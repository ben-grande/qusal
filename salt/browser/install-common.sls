{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - sys-usb.install-client-fido
  - sys-audio.install-client

"{{ slsdotpath }}-installed-common":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - qubes-core-agent-thunar

{% set pkg = {
  'Debian': {
    'pkg': ['thunar', 'libgdk-pixbuf2.0-bin'],
  },
  'RedHat': {
    'pkg': ['Thunar', 'gdk-pixbuf2'],
  },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-common-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
