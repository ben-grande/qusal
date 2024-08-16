{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - rsync
      - man-db

"{{ slsdotpath }}-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/server/systemd/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-unmask-rsync":
  service.unmasked:
    - name: rsync

"{{ slsdotpath }}-enable-rsync":
  service.enabled:
    - name: rsync

"{{ slsdotpath }}-set-rsyncd.conf":
  file.managed:
    - name: /etc/rsyncd.conf
    - source: salt://{{ slsdotpath }}/files/server/rsync/rsyncd.conf
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-rpc":
  file.symlink:
    - name: /etc/qubes-rpc/qusal.Rsync
    - target: /dev/tcp/127.0.0.1/873
    - user: root
    - group: root
    - force: True
    - makedirs: True

"{{ slsdotpath }}-rpc-config":
  file.symlink:
    - name: /etc/qubes/rpc-config/qusal.Rsync
    - target: /etc/qubes/rpc-config/qubes.ConnectTCP
    - user: root
    - group: root
    - force: True
    - makedirs: True

{% endif -%}
