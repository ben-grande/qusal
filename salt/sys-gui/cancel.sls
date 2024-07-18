{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - .cancel-common

"{{ slsdotpath }}-disable-autostart":
  qvm.prefs:
    - name: {{ slsdotpath }}
    - autostart: False
