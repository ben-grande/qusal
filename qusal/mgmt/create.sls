{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

"dvm-{{ slsdotpath }}":
  qvm.vm:
    - name: dvm-{{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: black
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: black
      - netvm: ""
      - dispvm-allowed: True
      - memory: 300
      - maxmem: 600
      - vcpus: 1
      - autostart: False
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - appmenus-dispvm
        - internal
