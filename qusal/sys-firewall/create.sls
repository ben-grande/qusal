{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

# Use the netvm of the default_netvm.
{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
{% set netvm = salt['cmd.shell']('qvm-prefs ' + default_netvm + ' netvm') -%}
# If netvm is empty, user's default_netvm is the uplink (sys-net).
{% if netvm == '' %}
  {% set netvm = default_netvm %}
{% endif -%}

"{{ slsdotpath }}":
  qvm.vm:
    - require:
      - sls: {{ slsdotpath }}.clone
    - name: {{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: orange
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: orange
      - memory: 300
      - maxmem: 400
      - netvm: {{ netvm }}
      - vcpus: 1
      - provides-network: True
      - include_in_backups: False
    - features:
      - enable:
        - servicevm
      - disable:
        - service.cups
        - service.cups-browsed

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
      - netvm: {{ netvm }}
      - memory: 300
      - maxmem: 400
      - vcpus: 1
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - servicevm
      - disable:
        - appmenus-dispvm
        - service.cups
        - service.cups-browsed

"disp-{{ slsdotpath }}":
  qvm.vm:
    - require:
      - qvm: dvm-{{ slsdotpath }}
    - name: disp-{{ slsdotpath }}
    - present:
      - template: dvm-{{ slsdotpath }}
      - label: orange
      - class: DispVM
    - prefs:
      - template: dvm-{{ slsdotpath }}
      - label: orange
      - netvm: {{ netvm }}
      - memory: 300
      - maxmem: 400
      - vcpus: 1
      - provides-network: True
      - autostart: False
      - include_in_backups: False
    - features:
      - enable:
        - servicevm
      - disable:
        - service.cups
        - service.cups-browsed
