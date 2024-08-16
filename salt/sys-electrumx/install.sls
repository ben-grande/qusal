{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - sys-bitcoin.install-client
  - dev.home-cleanup
  - dev.install-terminal
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - dotfiles.copy-git
  - sys-pgp.install-client
  - sys-git.install-client

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - socat
      - python3-aiohttp
      - python3-aiorpcx
      - python3-attr
      - python3-plyvel

"{{ slsdotpath }}-rpc":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/server/rpc
    - name: /etc/qubes-rpc/
    - dir_mode: '0755'
    - file_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-bin-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/server/bin
    - name: /usr/bin/
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
    - makedirs: True

"{{ slsdotpath }}-system-service-enable-electrumx":
  service.enabled:
    - name: electrumx

{% endif -%}
