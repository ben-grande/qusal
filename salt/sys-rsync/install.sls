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
    - pkgs:
      - rsync
      - socat
      - man-db

"{{ slsdotpath }}-stop-rsync":
  service.dead:
    - name: rsync

"{{ slsdotpath }}-disable-rsync":
  service.disabled:
    - name: rsync

"{{ slsdotpath }}-mask-rsync":
  service.masked:
    - name: rsync

"{{ slsdotpath }}-set-rsyncd.conf":
  file.managed:
    - name: /etc/rsyncd.conf
    - source: salt://{{ slsdotpath }}/files/server/rsync/rsyncd.conf
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-set-rpc-services":
  file.recurse:
    - name: /etc/qubes-rpc/
    - source: salt://{{ slsdotpath }}/files/server/rpc/
    - dir_mode: '0755'
    - file_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
