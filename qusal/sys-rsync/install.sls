{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - rsync
      - socat

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
