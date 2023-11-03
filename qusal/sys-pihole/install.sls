{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

{% set pihole_tag = 'v5.17.2' -%}

include:
  - dotfiles.copy-x11

{% set qubes_ip = salt['cmd.shell']('qubesdb-read /qubes-ip') %}
{% set qubes_gateway = salt['cmd.shell']('qubesdb-read /qubes-gateway') %}

"{{ slsdotpath }}-set-eth0-interface":
  file.managed:
    - name: /etc/network/interfaces.d/eth0
    - source: salt://{{ slsdotpath }}/files/server/network/eth0
    - mode: '0644'
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

"{{ slsdotpath }}-disable-external-admin-interface":
  file.managed:
    - name: /etc/lighttpd/conf-available/50-pihole.conf
    - source: salt://{{ slsdotpath }}/files/server/network/50-pihole.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-disable-external-admin-interface-symlink":
  file.symlink:
    - name: /etc/lighttpd/conf-available/50-pihole.conf
    - target: /etc/lighttpd/conf-enabled/50-pihole.conf
    - force: True

"{{ slsdotpath }}-disable-systemd-resolved":
  service.disabled:
    - name: systemd-resolved

"{{ slsdotpath }}-setupVars.conf":
  file.managed:
    - name: /etc/pihole/setupVars.conf
    - source: salt://{{ slsdotpath }}/files/server/network/setupVars.conf
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-git-clone":
  git.latest:
    - name: https://github.com/pi-hole/pi-hole.git
    - user: root
    - target: /root/pi-hole
    - force_fetch: True

"{{ slsdotpath }}-gnupg-home-for-pihole":
  file.directory:
    - name: /root/.gnupg/pihole
    - user: root
    - group: root
    - mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-keyring-and-trustdb":
  file.managed:
    - user: root
    - group: root
    - mode: '0600'
    - names:
      - /root/.gnupg/pihole/pubring.kbx:
        - source: salt://{{ slsdotpath }}/files/server/keys/pubring.kbx
      - /root/.gnupg/pihole/trustdb.gpg:
        - source: salt://{{ slsdotpath }}/files/server/keys/trustdb.gpg

## The tag is annotated, using verify-commit instead.
"{{ slsdotpath }}-git-verify-tag-pihole":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-git-clone"
    - name: GNUPGHOME="$HOME/.gnupg/pihole" git verify-commit {{ pihole_tag }}
    - cwd: /root/pi-hole
    - runas: root

"{{ slsdotpath }}-git-checkout-tag-{{ pihole_tag }}":
  cmd.run:
    - name: git checkout {{ pihole_tag }}
    - require:
      - cmd: "{{ slsdotpath }}-git-verify-tag-pihole"
    - cwd: /root/pi-hole
    - runas: root

"{{ slsdotpath }}-setup":
  cmd.run:
    - name: ./basic-install.sh --unattended
    - require:
      - cmd: "{{ slsdotpath }}-git-checkout-tag-{{ pihole_tag }}"
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
    - source: salt://{{ slsdotpath }}/files/server/firewall/update_nft.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'

"{{ slsdotpath }}-firewall-route-localnet":
  file.managed:
    - name: /rw/config/network-hooks.d/internalise.sh
    - source: salt://{{ slsdotpath }}/files/server/firewall/internalise.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'

"{{ slsdotpath }}-firewall-flush":
  file.managed:
    - name: /rw/config/network-hooks.d/flush.sh
    - source: salt://{{ slsdotpath }}/files/server/firewall/flush.sh
    - user: root
    - group: root
    - makedirs: True
    - mode: '0755'

"{{ slsdotpath }}-firewall-flush-rules":
  file.managed:
    - name: /rw/config/network-hooks.d/flush
    - source: salt://{{ slsdotpath }}/files/server/firewall/flush
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

"{{ slsdotpath }}-desktop-application-browser":
  file.managed:
    - name: /usr/share/applications/pihole-browser.desktop
    - source: salt://{{ slsdotpath }}/files/server/pihole-browser.desktop
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-desktop-application-open-general":
  file.managed:
    - name: /usr/share/applications/pihole-browser-general.desktop
    - source: salt://{{ slsdotpath }}/files/server/pihole-browser-general.desktop
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-etc-mimeapps.list":
  file.managed:
    - name: /etc/xdg/mimeapps.list
    - source: salt://{{ slsdotpath }}/files/server/mimeapps.list
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
