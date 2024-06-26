{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-get-updatevm-origin":
  file.managed:
    - name: /usr/local/bin/qusal-report-updatevm-origin
    - source: salt://{{ slsdotpath }}/files/admin/bin/qusal-report-updatevm-origin
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True
