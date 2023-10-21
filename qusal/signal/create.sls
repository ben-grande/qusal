{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone
  - .firewall

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: yellow
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: yellow
      - vpus: 1
      - memory: 400
      - maxmem: 600
      - autostart: False
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy

"set-tpl-{{ slsdotpath }}-appmenus":
  qvm.features:
    - name: tpl-{{ slsdotpath }}
    - set:
      - menu-items: "signal-desktop.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
      - default-menu-items: "signal-desktop.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"

"set-{{ slsdotpath }}-appmenus":
  qvm.features:
    - name: {{ slsdotpath }}
    - set:
      - menu-items: "signal-desktop.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"

{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus with context -%}
{{ sync_appmenus('tpl-' ~ sls_path) }}
