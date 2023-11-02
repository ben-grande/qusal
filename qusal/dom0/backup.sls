{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-backup-find-script":
  file.managed:
    - name: /usr/local/bin/qvm-backup-find-last
    - source: salt://{{ slsdotpath }}/files/bin/qvm-backup-find-last
    - mode: '0755'
    - user: root
    - group: root

"{{ slsdotpath }}-backup-profile":
  file.managed:
    - name: /etc/qubes/backup/qusal.conf
    - source: salt://{{ slsdotpath }}/files/backup/qusal.conf
    - mode: '0755'
    - user: root
    - group: root
    - replace: False
