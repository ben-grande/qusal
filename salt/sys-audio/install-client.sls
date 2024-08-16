{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-client-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - pipewire-qubes
      - wireplumber
      - rtkit

{% set pkg = {
    'Debian': {
      'pkg': ['dbus-user-session', 'libpam-systemd', 'pipewire-pulse',
              'pipewire-libcamera'],
    },
    'RedHat': {
      'pkg': ['dbus', 'systemd-pam', 'pipewire-pulseaudio',
              'pipewire-plugin-libcamera'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-client-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
