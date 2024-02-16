{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-bitcoind-listen-configuration":
  file.managed:
    - name: /home/user/.bitcoin/conf.d/listen.conf
    - source: salt://{{ slsdotpath }}/files/server/conf-optional/listen.conf
    - mode: '0600'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-whonix-firewall-open-bitcoin-listening":
  file.managed:
    - name: /usr/local/etc/whonix_firewall.d/40_qusal.conf
    - source: salt://{{ slsdotpath }}/files/server/whonix_firewall.d/40_qusal.conf
    - mode: '0600'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-whonix-firewall-reload":
  cmd.run:
    - name: whonix_firewall --info
    - runas: root

{% endif -%}
