{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-client-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-client-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - pipewire-qubes
      - pipewire-pulse
      - wireplumber
      - rtkit

{% set pkg = {
    'Debian': {
      'pkg': ['dbus-user-session', 'libpam-systemd'],
    },
    'RedHat': {
      'pkg': ['dbus', 'systemd-pam'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-client-installed-os-specific":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
