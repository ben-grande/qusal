{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dev.home-cleanup
  - dev.install-terminal
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - whonix-workstation.install-nostart-tbb

"{{ slsdotpath }}-common-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - man-db
      - bash-completion
      - jq
      - socat
      - curl

{% set pkg = {
  'Debian': {
    'pkg': ['libxcb1-dev', 'libxcb-icccm4', 'libxcb-image0-dev',
            'libxcb-keysyms1-dev', 'libxcb-render0-dev',
            'libxcb-render-util0-dev', 'libxcb-shape0-dev',
            'libxcb-xinerama0-dev', 'libxcb-xkb-dev', 'libxcb-xinput0',
            'libxkbcommon-x11-dev'],
  },
  'RedHat': {
    'pkg': ['libxcb', 'xcb-util', 'xcb-util-wm', 'xcb-util-image',
            'xcb-util-keysyms', 'libxkbcommon'],
  },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-common-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-bin":
  file.recurse:
    - name: /usr/bin/
    - source: salt://{{ slsdotpath }}/files/server/bin/
    - file_mode: '0755'
    - dir_mode: '0755'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-rpc":
  file.recurse:
    - name: /etc/qubes-rpc/
    - source: salt://{{ slsdotpath }}/files/server/rpc/
    - dir_mode: '0755'
    - file_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-system-systemd-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/server/systemd/
    - name: /usr/lib/systemd/system/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root

"{{ slsdotpath }}-system-service-enable-bitcoind":
  service.enabled:
    - name: bitcoind

{% endif -%}
