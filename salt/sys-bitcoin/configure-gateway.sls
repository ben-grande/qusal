{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-x11

"{{ slsdotpath }}-create-rc-script":
  file.managed:
    - name: /rw/config/rc.local.d/50-sys-bitcoin.rc
    - source: salt://{{ slsdotpath }}/files/gateway/rc.local.d/50-sys-bitcoin.rc
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-torrc-bitcoin-socksport":
  file.managed:
    - name: /usr/local/etc/torrc.d/40_qusal.conf
    - source: salt://{{ slsdotpath }}/files/gateway/torrc.d/40_qusal.conf
    - template: jinja
    - context:
        qube_ip: {{ salt['cmd.shell']('qubesdb-read /qubes-ip') }}
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-systemd-restart-tor@default":
  service.running:
    - name: tor@default
    - enable: True
    - reload: True
    - watch:
      - file: "{{ slsdotpath }}-torrc-bitcoin-socksport"

"{{ slsdotpath }}-whonix-firewall-open-socksport":
  file.managed:
    - name: /usr/local/etc/whonix_firewall.d/40_qusal.conf
    - source: salt://{{ slsdotpath }}/files/gateway/whonix_firewall.d/40_qusal.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-whonix-firewall-reload":
  cmd.run:
    - name: whonix_firewall --info
    - runas: root

{% endif -%}
