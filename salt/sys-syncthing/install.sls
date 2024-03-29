{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-repo
  - utils.tools.common.update

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install-repo
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - syncthing
      - jq
      - socat
      - qubes-core-agent-thunar
      - thunar

"{{ slsdotpath }}-rpc-service":
  file.managed:
    - name: /etc/qubes-rpc/qusal.Syncthing
    - source: salt://{{ slsdotpath }}/files/server/rpc/qusal.Syncthing
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-mask-syncthing":
  service.masked:
    - name: syncthing@user.service
    - runtime: False

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
