{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{% if grains['os_family']|lower == 'debian' -%}
include:
  - .install-repo
  - utils.tools.common.update
{% endif -%}

"{{ slsdotpath }}-installed":
  pkg.installed:
    {% if grains['os_family']|lower == 'debian' %}
    - require:
      - sls: {{ slsdotpath }}.install-repo
      - sls: utils.tools.common.update
    {% endif %}
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - syncthing
      - jq
      - man-db

"{{ slsdotpath }}-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/server/systemd/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-unmask-syncthing@user":
  service.unmasked:
    - name: syncthing@user.service
    - runtime: False

"{{ slsdotpath }}-enable-syncthing@user":
  service.enabled:
    - name: syncthing@user.service

"{{ slsdotpath }}-rpc":
  file.symlink:
    - name: /etc/qubes-rpc/qusal.Syncthing
    - target: /dev/tcp/127.0.0.1/22000
    - user: root
    - group: root
    - force: True
    - makedirs: True

"{{ slsdotpath }}-rpc-config":
  file.symlink:
    - name: /etc/qubes/rpc-config/qusal.Syncthing
    - target: /etc/qubes/rpc-config/qubes.ConnectTCP
    - user: root
    - group: root
    - force: True
    - makedirs: True

"{{ slsdotpath }}-desktop-application-browser":
  file.managed:
    - name: /usr/share/applications/syncthing-browser.desktop
    - source: salt://{{ slsdotpath }}/files/server/syncthing-browser.desktop
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-desktop-application-open-general":
  file.managed:
    - name: /usr/share/applications/syncthing-browser-general.desktop
    - source: salt://{{ slsdotpath }}/files/server/syncthing-browser-general.desktop
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
