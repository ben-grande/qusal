{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-config-vpn":
  file.directory:
    - name: /rw/config/vpn
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-rc.local":
  file.managed:
    - name: /rw/config/rc.local.d/50-sys-wireguard.rc
    - source: salt://{{ slsdotpath }}/files/server/rc.local.d/50-sys-wireguard.rc
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-wg-conf.sh":
  file.managed:
    - name: /home/user/wg-conf.sh
    - source: salt://{{ slsdotpath }}/files/server/wg-conf.sh
    - mode: '0755'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-firewall-filter":
  file.managed:
    - name: /rw/config/qubes-firewall.d/60-sys-wireguard-filter
    - source: salt://{{ slsdotpath }}/files/server/qubes-firewall.d/60-sys-wireguard-filter
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-firewall-flush":
  file.managed:
    - name: /rw/config/network-hooks.d/flush.sh
    - source: salt://{{ slsdotpath }}/files/server/flush.sh
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-firewall-flush-rules":
  file.managed:
    - name: /rw/config/network-hooks.d/flush
    - source: salt://{{ slsdotpath }}/files/server/flush
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'
