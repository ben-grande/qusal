{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-rc.local":
  file.managed:
    - name: /rw/config/rc.local.d/50-docker.rc
    - source: salt://{{ slsdotpath }}/files/client/rc.local.d/50-docker.rc
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
