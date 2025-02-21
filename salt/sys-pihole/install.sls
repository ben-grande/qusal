{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

{% set pihole_tag = 'v6.0.6' -%}

include:
  - utils.tools.common.update
  - sys-cacher.uninstall-client
  - sys-net.install-proxy
  - dotfiles.copy-x11

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - fwupd-qubes-vm
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-dom0-updates
      - qubes-core-agent-networking
      - systemd-timesyncd
      - git
      - idn2
      - man-db
      ## Other dependencies brought by local package pihole-meta.

"{{ slsdotpath }}-disable-lighttpd":
  service.disabled:
    - name: lighttpd

"{{ slsdotpath }}-disable-systemd-resolved":
  service.disabled:
    - name: systemd-resolved

"{{ slsdotpath }}-git-clone":
  git.latest:
    - name: https://github.com/pi-hole/pi-hole.git
    - rev: {{ pihole_tag }}
    - user: root
    - target: /root/pi-hole
    - force_fetch: True

"{{ slsdotpath }}-gnupg-home":
  file.directory:
    - name: /root/.gnupg/pihole
    - user: root
    - group: root
    - mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-save-keys":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-gnupg-home"
    - name: /root/.gnupg/pihole/download/
    - source: salt://{{ slsdotpath }}/files/server/keys/
    - user: user
    - group: user
    - file_mode: '0600'
    - dir_mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-import-keys":
  cmd.run:
    - require:
      - file: "{{ slsdotpath }}-save-keys"
    - name: gpg --homedir . --import download/*.asc
    - cwd: /root/.gnupg/pihole
    - runas: root

"{{ slsdotpath }}-import-ownertrust":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
    - name: gpg --homedir . --import-ownertrust download/otrust.txt
    - cwd: /root/.gnupg/pihole
    - runas: root

## The tag is annotated, using verify-commit instead.
"{{ slsdotpath }}-git-verify-tag-pihole":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-git-clone"
    - env:
      - GNUPGHOME: "/home/user/.gnupg/pihole"
    - name: git -c gpg.program=gpg2 verify-commit {{ pihole_tag }}
    - cwd: /root/pi-hole
    - runas: root

"{{ slsdotpath }}-git-checkout-tag-{{ pihole_tag }}":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-git-verify-tag-pihole"
    - name: git checkout {{ pihole_tag }}
    - cwd: /root/pi-hole
    - runas: root

"{{ slsdotpath }}-setup":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-git-checkout-tag-{{ pihole_tag }}"
    - name: ./basic-install.sh --unattended
    - cwd: '/root/pi-hole/automated install'
    - runas: root

"{{ slsdotpath }}-add-user-to-pihole-group":
  group.present:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole
    - addusers:
      - user

"{{ slsdotpath }}-set-empty-api-password":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: printf '' | pihole setpassword
    - runas: root

"{{ slsdotpath }}-set-upstream-dns-servers":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config dns.upstreams '[ "9.9.9.9", "149.112.112.112" ]'
    - runas: root

"{{ slsdotpath }}-enable-blocking":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config dns.blocking.active true
    - runas: root

"{{ slsdotpath }}-set-domain-interface":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config dns.interface eth0
    - runas: root

"{{ slsdotpath }}-enable-domain-needed-fqdn":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config dns.domainNeeded true
    - runas: root

"{{ slsdotpath }}-enable-expand-hosts-fqdn":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config dns.expandHosts true
    - runas: root


"{{ slsdotpath }}-set-dark-theme":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config webserver.interface.theme default-dark
    - runas: root

"{{ slsdotpath }}-restrict-webserver-acl-to-localhost":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config webserver.acl "+127.0.0.1,+[::1]"
    - runas: root

"{{ slsdotpath }}-disable-ntp-sync":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config ntp.sync.active false
    - runas: root

"{{ slsdotpath }}-disable-ntp-ipv4":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config ntp.ipv4.active false
    - runas: root

"{{ slsdotpath }}-disable-ntp-ipv6":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config ntp.ipv6.active false
    - runas: root

"{{ slsdotpath }}-enable-loading-dnsmasq.d":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-setup"
    - name: pihole-FTL --config misc.etc_dnsmasq_d true
    - runas: root

"{{ slsdotpath }}-firewall":
  file.managed:
    - name: /rw/config/qubes-firewall.d/50-sys-pihole
    - source: salt://{{ slsdotpath }}/files/server/qubes-firewall.d/50-sys-pihole
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-network-hooks":
  file.managed:
    - name: /rw/config/network-hooks.d/50-sys-pihole.sh
    - source: salt://{{ slsdotpath }}/files/server/network-hooks.d/50-sys-pihole.sh
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-dnsmasq":
  file.managed:
    - name: /etc/dnsmasq.d/00-pihole.conf
    - source: salt://{{ slsdotpath }}/files/server/dnsmasq.d/00-pihole.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

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
