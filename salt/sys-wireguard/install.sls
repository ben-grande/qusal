{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - sys-net.install-proxy

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - iproute2
      - resolvconf
      - wireguard
      - unzip
      - curl
      - man-db

"{{ slsdotpath }}-bind-dirs":
  file.managed:
    - name: /etc/qubes-bind-dirs.d/50-{{ slsdotpath }}.conf
    - source: salt://{{ slsdotpath }}/files/server/qubes-bind-dirs.d/50-{{ slsdotpath }}.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

"{{ slsdotpath }}-systemd-service":
  file.managed:
    - name: /usr/lib/systemd/system/wg-quick@wireguard.service.d/50_qusal.conf
    - source: salt://{{ slsdotpath }}/files/server/systemd/wg-quick@wireguard.service.d/50_qusal.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

"{{ slsdotpath }}-enable-wg-quick@wireguard":
  service.enabled:
    - name: wg-quick@wireguard

{% endif -%}
