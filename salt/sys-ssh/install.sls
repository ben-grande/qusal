{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
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

"{{ slsdotpath }}-set-rpc-services":
  file.recurse:
    - name: /etc/qubes-rpc/
    - source: salt://{{ slsdotpath }}/files/server/rpc/
    - dir_mode: '0755'
    - file_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-sshd-config":
  file.managed:
    - name: /etc/ssh/sshd_config.d/{{ slsdotpath }}.conf
    - source: salt://{{ slsdotpath }}/files/server/sshd_config.d/{{ slsdotpath }}.conf
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
