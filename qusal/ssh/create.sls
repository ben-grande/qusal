{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: blue
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: blue
      - vpus: 1
      - memory: 400
      - maxmem: 500
      - autostart: False
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy

"dvm-{{ slsdotpath }}":
  qvm.vm:
    - name: dvm-{{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: blue
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: blue
      - vpus: 1
      - memory: 400
      - maxmem: 500
      - autostart: False
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - appmenus-dispvm
      - disable:
        - service.cups
        - service.cups-browsed
