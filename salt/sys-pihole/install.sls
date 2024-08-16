{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

{% set pihole_tag = 'v5.18.3' -%}

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
      - bash-completion
      - man-db

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
    - require:
      - file: "{{ slsdotpath }}-disable-external-admin-interface"
    - name: /etc/lighttpd/conf-enabled/50-pihole.conf
    - target: /etc/lighttpd/conf-available/50-pihole.conf
    - force: True

"{{ slsdotpath }}-disable-systemd-resolved":
  service.disabled:
    - name: systemd-resolved

"{{ slsdotpath }}-setupVars.conf":
  file.managed:
    - name: /etc/pihole/setupVars.conf
    - source: salt://{{ slsdotpath }}/files/server/pihole/setupVars.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

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
    - name: gpg --status-fd=2 --homedir . --import download/*.asc
    - cwd: /root/.gnupg/pihole
    - runas: root
    - success_stderr: IMPORT_OK

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
