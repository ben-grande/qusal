{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-remove-service-from-rc.local":
  file.replace:
    - name: /rw/config/rc.local
    - pattern: 'systemctl.*unmask.*syncthing@user.service'
    - repl: ''
    - backup: False
