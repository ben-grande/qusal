{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-home-config-mimeapps.list":
  file.managed:
    - name: /home/user/.config/mimeapps.list
    - source: salt://{{ slsdotpath }}/files/client/mimeapps.list
    - mode: '0644'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-home-local-share-mimeapps.list":
  file.symlink:
    - name: /home/user/.config/mimeapps.list
    - target: /home/user/.local/share/applications/mimeapps.list
    - user: user
    - group: user
    - makedirs: True
    - force: True

{% endif -%}
