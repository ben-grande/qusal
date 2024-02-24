{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
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
    - name: /etc/qubes/backup/qusal.conf.example
    - source: salt://{{ slsdotpath }}/files/backup/qusal.conf.example
    - mode: '0644'
    - user: root
    - group: qubes
    - makedirs: True
