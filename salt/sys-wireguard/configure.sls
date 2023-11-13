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
  file.append:
    - name: /rw/config/rc.local
    - text: wg-quick up /rw/config/vpn/wireguard.conf

"{{ slsdotpath }}-add-config.sh":
  file.managed:
    - name: /home/user/add-config.sh
    - source: salt://{{ slsdotpath }}/files/server/add-config.sh
    - user: user
    - group: user
    - mode: '0755'
    - replace: True

"{{ slsdotpath }}-qubes-firewall-user-script":
  file.append:
    - name: /rw/config/qubes-firewall-user-script
    - text:
      - nft insert rule filter FORWARD tcp flags syn tcp option maxseg size set rt mtu
      - nft insert rule filter FORWARD oifname eth0 drop
      - nft insert rule filter FORWARD iifname eth0 drop

"{{ slsdotpath }}-firewall-flush":
  file.managed:
    - name: /rw/config/network-hooks.d/flush.sh
    - source: salt://{{ slsdotpath }}/files/server/flush.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'

"{{ slsdotpath }}-set-firewall-flush-rules":
  file.managed:
    - name: /rw/config/network-hooks.d/flush
    - source: salt://{{ slsdotpath }}/files/server/flush
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'
