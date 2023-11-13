{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-append-to-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: |
        systemctl unmask syncthing@user.service
        systemctl --no-block restart  syncthing@user.service
