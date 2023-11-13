{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - sys-usb.install-client-proxy

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-admin-client
      - qubes-audio-daemon
      - pipewire-qubes
      - alsa-utils
      - volumeicon-alsa
      - socat

{% set pkg = {
    'Debian': {
      'pkg': ['pipewire', 'libpam-systemd'],
    },
    'RedHat': {
      'pkg': ['pipewire-utils', 'systemd-pam'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
