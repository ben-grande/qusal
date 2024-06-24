{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-installed-client":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - socat

"{{ slsdotpath }}-client-systemd-print-forwarder":
  file.managed:
    - name: /usr/lib/systemd/system/qusal-print-forwarder.service
    - source: salt://{{ slsdotpath }}/files/client/systemd/qusal-print-forwarder.service
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-enable-systemd-service-print-forwarder":
  service.enabled:
    - name: qusal-print-forwarder.service
