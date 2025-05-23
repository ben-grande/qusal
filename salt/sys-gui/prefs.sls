{#
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-autostart":
  qvm.prefs:
    - name: {{ slsdotpath }}
    - autostart: True

"{{ slsdotpath }}-activate":
  cmd.run:
    - require:
      - qvm: "{{ slsdotpath }}-autostart"
    - name: qubes-prefs -- default_guivm {{ slsdotpath }}

"{{ slsdotpath }}-set-tpl-{{ slsdotpath }}-management_dispvm-to-default":
  qvm.vm:
    - require:
      - sls: {{ slsdotpath }}.create
    - name: tpl-{{ slsdotpath }}
    - prefs:
      - management_dispvm: "*default*"
