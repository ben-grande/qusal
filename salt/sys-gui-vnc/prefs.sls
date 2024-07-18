{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-vnc-autostart":
  qvm.prefs:
    - name: {{ slsdotpath }}-vnc
    - autostart: True

"{{ slsdotpath }}-vnc-activate":
  cmd.run:
    - require:
      - qvm: "{{ slsdotpath }}-vnc-autostart"
    - name: qubes-prefs default_guivm {{ slsdotpath }}-vnc
