{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

"tpl-{{ slsdotpath }}":
  qvm.vm:
    - name: tpl-{{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - features:
      - set:
        - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop org.remmina.Remmina.desktop"
        - menu-items: "qubes-run-terminal.desktop qubes-start.desktop org.remmina.Remmina.desktop"

"dvm-{{ slsdotpath }}":
  qvm.vm:
    - name: dvm-{{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: orange
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: orange
      - memory: 300
      - maxmem: 600
      - vcpus: 1
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - appmenus-dispvm
      - set:
        - menu-items: "qubes-run-terminal.desktop qubes-start.desktop org.remmina.Remmina.desktop"

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: orange
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: orange
      - memory: 300
      - maxmem: 600
      - vcpus: 1
      - include_in_backups: False
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
      - set:
        - menu-items: "qubes-run-terminal.desktop qubes-start.desktop org.remmina.Remmina.desktop"
