{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{% if grains['os_family']|lower == 'debian' -%}
include:
  - .install-repo
  - utils.tools.common.update
{% endif -%}

"{{ slsdotpath }}-client-installed":
  pkg.installed:
    {% if grains['os_family']|lower == 'debian' -%}
    - require:
      - sls: {{ slsdotpath }}.install-repo
      - sls: utils.tools.common.update
    {% endif %}
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - syncthing
      - jq
      - man-db

"{{ slsdotpath }}-client-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/client/systemd/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-client-systemd-enable-qusal-syncthing-forwarder.socket":
  service.enabled:
    - name: qusal-syncthing-forwarder.socket

"{{ slsdotpath }}-server-systemd":
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


{% endif -%}
