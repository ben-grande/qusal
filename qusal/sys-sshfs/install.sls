{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Qusal contributors

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
      - openssh-server
      - socat

"{{ slsdotpath }}-stop-ssh":
  service.dead:
    - name: ssh

"{{ slsdotpath }}-disable-ssh":
  service.disabled:
    - name: ssh

"{{ slsdotpath }}-mask-ssh":
  service.masked:
    - name: ssh

"{{ slsdotpath }}-set-rpc-service":
  file.managed:
    - name: /etc/qubes-rpc/qusal.Sshfs
    - source: salt://{{ slsdotpath }}/files/rpc/qusal.Sshfs
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
