{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

Source: https://github.com/romanz/electrs/blob/master/doc/install.md
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dev.home-cleanup
  - dev.install-terminal
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - dotfiles.copy-git
  - sys-bitcoin.install-client
  - sys-git.install-client
  - sys-pgp.install-client

"{{ slsdotpath }}-source-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - socat
      - librocksdb-dev
      - man-db

"{{ slsdotpath }}-rpc":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/server/rpc/
    - name: /etc/qubes-rpc/
    - dir_mode: '0755'
    - file_mode: '0755'
    - user: root
    - group: root

"{{ slsdotpath }}-system-systemd-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/server/systemd/
    - name: /usr/lib/systemd/system/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root

"{{ slsdotpath }}-system-service-enable-bitcoin-p2p-qrexec":
  service.enabled:
    - name: bitcoin-p2p-qrexec.socket

"{{ slsdotpath }}-system-service-enable-electrs":
  service.enabled:
    - name: electrs

{% endif -%}
