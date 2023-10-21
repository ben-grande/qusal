{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

"tpl-{{ slsdotpath }}":
  qvm.vm:
    - name: tpl-{{ slsdotpath }}
    - features:
      - set:
        - menu-items: "org.keepassxc.KeePassXC.desktop qubes-run-terminal.desktop qubes-start.desktop"
        - default-menu-items: "org.keepassxc.KeePassXC.desktop qubes-run-terminal.desktop qubes-start.desktop"

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: black
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: black
      - netvm: ""
      - memory: 400
      - maxmem: 600
      - vcpus: 1
      - autostart: False
      - include_in_backups: True
    - features:
      - set:
        - menu-items: "org.keepassxc.KeePassXC.desktop qubes-run-terminal.desktop qubes-start.desktop"
