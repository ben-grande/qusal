{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - dotfiles.copy-xfce

"{{ slsdotpath }}-rc.local":
  file.managed:
    - name: /rw/config/rc.local.d/50-sys-syncthing.rc
    - source: salt://{{ slsdotpath }}/files/server/rc.local.d/50-sys-syncthing.rc
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True
