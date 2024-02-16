{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-offline-rc":
  file.recurse:
    - name: /rw/config/rc.local.d/
    - source: salt://{{ slsdotpath }}/files/offline/rc.local.d/
    - dir_mode: '0755'
    - file_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-offline-sdwdate-gui":
  file.recurse:
    - name: /usr/local/etc/sdwdate-gui.d/
    - source: salt://{{ slsdotpath }}/files/offline/sdwdate-gui.d/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% endif %}
