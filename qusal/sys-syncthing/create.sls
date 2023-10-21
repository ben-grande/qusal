{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
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
    - prefs:
      - vcpus: 1
      - memory: 300
      - maxmem: 700
      - autostart: False
      - include_in_backups: False
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
      - set:
        - menu-items: "qubes-run-terminal.desktop qubes-start.desktop firefox-esr.desktop syncthing-ui.desktop"
        - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop firefox-esr.desktop syncthing-ui.desktop"

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: gray
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: gray
      - vcpus: 1
      - memory: 300
      - maxmem: 700
      - autostart: False
      - include_in_backups: True
    - features:
      - enable:
        - servicevm
      - disable:
        - service.cups
        - service.cups-browsed
      - set:
        - menu-items: "qubes-run-terminal.desktop qubes-start.desktop firefox-esr.desktop syncthing-ui.desktop"

"{{ slsdotpath }}-resize-private-volume":
  cmd.run:
    - require:
      - qvm: {{ slsdotpath }}
    - name: qvm-volume extend {{ slsdotpath }}:private 50Gi

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
