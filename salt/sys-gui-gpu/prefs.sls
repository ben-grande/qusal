{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - qvm.sys-gui-gpu-attach-gpu

"{{ slsdotpath }}-gpu-autostart":
  qvm.prefs:
    - name: {{ slsdotpath }}-gpu
    - autostart: True

"{{ slsdotpath }}-gpu-activate":
  cmd.run:
    - require:
      - qvm: "{{ slsdotpath }}-gpu-autostart"
    - name: qubes-prefs default_guivm {{ slsdotpath }}-gpu
