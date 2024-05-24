{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-systemd-print-forwarder":
  file.managed:
    - name: /usr/lib/systemd/system/qubes-print-forwarder.service
    - source: salt://{{ slsdotpath }}/files/client/systemd/qubes-print-forwarder.service
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True
