{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - sys-gui.cancel-common
  - qvm.sys-gui-gpu-detach-gpu

"{{ slsdotpath }}-gpu-disable-autostart":
  qvm.prefs:
    - name: {{ slsdotpath }}-gpu
    - autostart: False
