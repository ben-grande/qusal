{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11

"{{ slsdotpath }}-install-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: |
        chown -R apt-cacher-ng:apt-cacher-ng /var/log/apt-cacher-ng
        chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng
        systemctl unmask qubes-apt-cacher-ng
        systemctl --no-block restart qubes-apt-cacher-ng
        nft 'insert rule ip filter INPUT tcp dport 8082 counter accept'

"{{ slsdotpath }}-install-qubes-firewall-user-script":
  file.append:
    - name: /rw/config/qubes-firewall-user-script
    - text: nft 'insert rule ip filter INPUT tcp dport 8082 counter accept'

"{{ slsdotpath }}-bind-dirs":
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/50_cacher.conf
    - source: salt://{{ slsdotpath }}/files/server/bind-dirs/50_cacher.conf
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
