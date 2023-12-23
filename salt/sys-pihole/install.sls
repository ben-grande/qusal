{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
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
      - systemd-timesyncd
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
    - source: salt://{{ slsdotpath }}/files/server/lighttpd/50-pihole.conf
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
    - source: salt://{{ slsdotpath }}/files/server/pihole/setupVars.conf
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

"{{ slsdotpath }}-firewall-nat":
  file.managed:
    - name: /rw/config/qubes-firewall.d/70-sys-pihole-nat
    - source: salt://{{ slsdotpath }}/files/server/qubes-firewall.d/70-sys-pihole-nat
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-firewall-filter":
  file.managed:
    - name: /rw/config/qubes-firewall.d/50-sys-pihole-filter
    - source: salt://{{ slsdotpath }}/files/server/qubes-firewall.d/50-sys-pihole-filter
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-firewall-internalise":
  file.managed:
    - name: /rw/config/network-hooks.d/60-sys-pihole-internalise
    - source: salt://{{ slsdotpath }}/files/server/qubes-firewall.d/60-sys-pihole-internalise
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-firewall-flush":
  file.managed:
    - name: /rw/config/network-hooks.d/flush.sh
    - source: salt://{{ slsdotpath }}/files/server/network-hooks.d/flush.sh
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-firewall-flush-rules":
  file.managed:
    - name: /rw/config/network-hooks.d/flush
    - source: salt://{{ slsdotpath }}/files/server/network-hooks.d/flush
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

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
