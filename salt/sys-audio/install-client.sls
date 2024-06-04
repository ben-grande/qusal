{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  ## TODO: video-companion covers camera, what about external USB speakers/mic?
  ## qubes-usb-proxy: external USB microphone and speakers
  - sys-usb.install-client-proxy

"{{ slsdotpath }}-client-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - pipewire-qubes
      - pipewire-pulse
      - pipewire-libcamera
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
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
