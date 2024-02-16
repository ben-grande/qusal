{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-do-not-start-torbrowser":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/template/torbrowser.d/
    - name: /etc/torbrowser.d/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
