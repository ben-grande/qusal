{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-allow-testing-repository":
  file.uncomment:
    - name: /etc/apt/sources.list.d/qubes-r4.list
    - regex: ^deb\s.*qubes-os.org.*-testing
    - backup: False

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - qubes-app-shutdown-idle
      - ca-certificates
      - anacron
      - apt-cacher-ng

"{{ slsdotpath }}-mask-apt-cacher-ng":
  service.masked:
    - name: apt-cacher-ng
    - runtime: False

"{{ slsdotpath }}-disable-apt-cacher-ng":
  service.disabled:
    - name: apt-cacher-ng

"{{ slsdotpath }}-create-qubes-cacher-config-dir":
  file.directory:
    - name: /etc/qubes-apt-cacher-ng
    - mode: '0755'

"{{ slsdotpath }}-copy-package-config-to-qubes-cacher-config":
  cmd.run:
    - name: cp -rp /etc/apt-cacher-ng/* /etc/qubes-apt-cacher-ng

"{{ slsdotpath }}-systemd-service":
  file.managed:
    - name: /usr/lib/systemd/system/apt-cacher-ng.service.d/50_qusal.conf
    - source: salt://{{ slsdotpath }}/files/server/systemd/apt-cacher-ng.service.d/50_qusal.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

"{{ slsdotpath }}-mask-qubes-apt-cacher-ng":
  service.masked:
    - name: qubes-apt-cacher-ng
    - runtime: False

"{{ slsdotpath }}-disable-qubes-apt-cacher-ng":
  service.disabled:
    - name: qubes-apt-cacher-ng

"{{ slsdotpath }}-install-backends_debian":
  file.prepend:
    - name: /etc/qubes-apt-cacher-ng/backends_debian
    - text: https://deb.debian.org/debian

"{{ slsdotpath }}-update-debian-mirrors":
  cmd.run:
    - name: cp /usr/lib/apt-cacher-ng/deb_mirrors.gz /etc/qubes-apt-cacher-ng/deb_mirrors.gz
    - runas: root

"{{ slsdotpath }}-update-fedora-mirrors":
  file.managed:
    - name: /etc/qubes-apt-cacher-ng/fedora_mirrors
    - source: salt://{{ slsdotpath }}/files/server/mirrors/fedora_mirrors
    - user: root
    - group: root

"{{ slsdotpath }}-update-arch-mirrors":
  file.managed:
    - name: /etc/qubes-apt-cacher-ng/archlx_mirrors
    - source: salt://{{ slsdotpath }}/files/server/mirrors/archlx_mirrors
    - user: root
    - group: root

"{{ slsdotpath }}-lib-qubes-bind-dirs":
  file.managed:
    - name: /usr/lib/qubes-bind-dirs.d/50-sys-cacher.conf
    - source: salt://{{ slsdotpath }}/files/server/lib-qubes-bind-dirs.d/50-sys-cacher.conf
    - mode: '0644'
    - user: root
    - group: root

"{{ slsdotpath }}-acng.conf":
  file.managed:
    - name: /etc/qubes-apt-cacher-ng/acng.conf
    - source: salt://{{ slsdotpath }}/files/server/conf/acng.conf
    - mode: '0644'
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
