{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-remove-service-from-rc.local":
  file.absent:
    - name: /rw/config/rc.local.d/50-sys-syncthing.rc
