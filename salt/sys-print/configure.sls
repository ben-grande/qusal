{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-bind-dirs":
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/50-sys-print.conf
    - source: salt://{{ slsdotpath }}/files/server/qubes-bind-dirs.d/50-sys-print.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-rpc":
  file.managed:
    - name: /etc/qubes-rpc/qusal.Print
    - source: salt://{{ slsdotpath }}/files/server/rpc/qusal.Print
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True
