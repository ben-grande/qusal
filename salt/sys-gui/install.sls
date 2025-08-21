{#
SPDX-FileCopyrightText: 2019 Frederic Pierret <frederic.pierret@qubes-os.org>
SPDX-FileCopyrightText: 2020 - 2024 Marmarek Marczykowski-Gorecki <marmarek@invisiblethingslab.com>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-2.0-only

Upstream pkg.installed installs weak_deps/recommends.
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dotfiles.copy-all

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      # Qubes related packages
      - qubes-core-agent-passwordless-root
      - qubes-gui-daemon-selinux
      - qubes-desktop-linux-manager
      - qubes-manager
      - qubes-vm-guivm


{% set pkg = {
  'Debian': {
    'pkg': [
      'gnome-themes-standard',
      'breeze-cursor-theme', 'breeze-icon-theme', 'breeze-gtk-theme', 'gtk3-engines-breeze',
      'lightdm',
      'xscreensaver',
    ]
  },
  'RedHat': {
    'pkg': ['dummy-psu-receiver', 'dummy-psu-module', 'dummy-backlight-vm',
            'adwaita-gtk2-theme', 'adwaita-icon-theme',
            'breeze-cursor-theme', 'breeze-icon-theme', 'breeze-gtk',
            'lightdm-gtk',
            'xscreensaver-base',
            ]
  },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-lightdm-service-unit":
  file.managed:
    - name: /usr/lib/systemd/system/lightdm.service.d/qubes.conf
    - source: salt://{{ slsdotpath }}/files/server/systemd/lightdm.service.d/qubes.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-lightdm-service-enabled":
  service.enabled:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: lightdm

"{{ slsdotpath }}-lock-root":
  user.present:
    - name: root
    - password: '!!'

{% endif -%}
