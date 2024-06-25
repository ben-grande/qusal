{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-client-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/client/systemd/
    - file_mode: '0644'
    - dir_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-enable-systemd-service-print-forwarder.socket":
  service.enabled:
    - name: qusal-print-forwarder.socket
