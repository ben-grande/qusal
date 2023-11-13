{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-allow-testing-repository":
  file.uncomment:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - regex: ^deb\s.*qubes-os.org.*-testing
    - backup: false

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - qubes-app-shutdown-idle
      - ca-certificates
      - anacron
      - apt-cacher-ng

"{{ slsdotpath }}-disable-apt-cacher-ng":
  cmd.run:
    - name: systemctl disable apt-cacher-ng

"{{ slsdotpath }}-mask-apt-cacher-ng":
  service.masked:
    - name: apt-cacher-ng
    - runtime: False

"{{ slsdotpath }}-install-backends_debian":
  file.prepend:
    - name: /etc/apt-cacher-ng/backends_debian
    - text: https://deb.debian.org/debian

"{{ slsdotpath }}-update-debian-mirrors":
  cmd.run:
    - name: cp /usr/lib/apt-cacher-ng/deb_mirrors.gz /etc/apt-cacher-ng/deb_mirrors.gz
    - runas: root

"{{ slsdotpath }}-update-fedora-mirrors":
  file.managed:
    - name: /etc/apt-cacher-ng/fedora_mirrors
    - source: salt://{{ slsdotpath }}/files/server/mirrors/fedora_mirrors
    - user: root
    - group: root

"{{ slsdotpath }}-update-arch-mirrors":
  file.managed:
    - name: /etc/apt-cacher-ng/archlx_mirrors
    - source: salt://{{ slsdotpath }}/files/server/mirrors/archlx_mirrors
    - user: root
    - group: root

"{{ slsdotpath }}-qubes-bind-dirs":
  file.append:
    - name: /usr/lib/qubes-bind-dirs.d/30_cron.conf
    - text: "binds+=( ' /etc/anacrontab' )"

"{{ slsdotpath }}-acng.conf":
  file.managed:
    - name: /etc/apt-cacher-ng/acng.conf
    - source: salt://{{ slsdotpath }}/files/server/conf/acng.conf
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-desktop-application-browser":
  file.managed:
    - name: /usr/share/applications/cacher-browser.desktop
    - source: salt://{{ slsdotpath }}/files/server/cacher-browser.desktop
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-desktop-application-open-general":
  file.managed:
    - name: /usr/share/applications/cacher-browser-general.desktop
    - source: salt://{{ slsdotpath }}/files/server/cacher-browser-general.desktop
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
