{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

include:
  - dotfiles.copy-x11

{% set qubes_ip = salt['cmd.shell']('qubesdb-read /qubes-ip') %}
{% set qubes_gateway = salt['cmd.shell']('qubesdb-read /qubes-gateway') %}

"{{ slsdotpath }}-set-eth0-interface":
  file.managed:
    - name: /etc/network/interfaces.d/eth0
    - source: salt://{{ slsdotpath }}/files/network/eth0
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-set-ip":
  file.line:
    - name: /etc/network/interfaces.d/eth0
    - match: address
    - mode: replace
    - content: "address {{ qubes_ip }}"

"{{ slsdotpath }}-set-gateway":
  file.line:
    - name: /etc/network/interfaces.d/eth0
    - match: gateway
    - mode: replace
    - content: "gateway {{ qubes_gateway }}"

"{{ slsdotpath }}-restart-networking":
  cmd.run:
    - name: systemctl restart networking
    - runas: root

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-dom0-updates
      - qubes-core-agent-networking
      - ca-certificates
      - curl
      - dnsutils
      - firefox-esr
      - git
      - idn2
      - lighttpd
      - netcat-openbsd
      - php-cgi
      - php-common
      - php-intl
      - php-json
      - php-sqlite3
      - php-xml
      - unzip

"{{ slsdotpath }}-disable-systemd-resolved":
  service.disabled:
    - name: systemd-resolved

"{{ slsdotpath }}-git-clone":
  git.latest:
    - name: https://github.com/pi-hole/pi-hole.git
    - user: root
    - target: /root/pi-hole

"{{ slsdotpath }}-setupVars.conf":
  file.managed:
    - name: /etc/pihole/setupVars.conf
    - source: salt://{{ slsdotpath }}/files/network/setupVars.conf
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-setup":
  cmd.run:
    - name: ./basic-install.sh --unattended'
    - cwd: '/root/pi-hole/automated install'
    - runas: root

"{{ slsdotpath }}-qubes-firewall-user-script":
  file.append:
    - name: /rw/config/qubes-firewall-user-script
    - text:
      - nft flush chain nat PR-QBS
      - nft insert rule nat PR-QBS iifname "vif*" tcp dport 53 dnat to 127.0.0.1
      - nft insert rule nat PR-QBS iifname "vif*" udp dport 53 dnat to 127.0.0.1

"{{ slsdotpath }}-firewall-update-nft-rules":
  file.managed:
    - name: /rw/config/qubes-firewall.d/update_nft.sh
    - source: salt://{{ slsdotpath }}/files/firewall/update_nft.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'

"{{ slsdotpath }}-firewall-route-localnet":
  file.managed:
    - name: /rw/config/network-hooks.d/internalise.sh
    - source: salt://{{ slsdotpath }}/files/firewall/internalise.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'

"{{ slsdotpath }}-firewall-flush":
  file.managed:
    - name: /rw/config/network-hooks.d/flush.sh
    - source: salt://{{ slsdotpath }}/files/firewall/flush.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'

"{{ slsdotpath }}-firewall-flush-rules":
  file.managed:
    - name: /rw/config/network-hooks.d/flush
    - source: salt://{{ slsdotpath }}/files/firewall/flush
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'

"{{ slsdotpath }}-dnsmasq":
  file.prepend:
    - name: /etc/dnsmasq.conf
    - text:
      - interface=lo
      - bind-interfaces

{% endif -%}
