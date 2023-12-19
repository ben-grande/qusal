{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-rc.local":
  file.managed:
    - name: /rw/config/rc.local.d/50-sys-syncthing.rc
    - source: salt://{{ slsdotpath }}/files/XXXXXXXXXXX/rc.local.d/50-sys-syncthing.rc
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True
