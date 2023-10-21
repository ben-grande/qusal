{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - .clone

"{{ template.template_clean }}":
  qvm.vm:
    - name: {{ template.template_clean }}
    - require:
      - sls: {{ template.template_clean }}.clone
    - present:
      - label: black
    - prefs:
      - label: black
      - memory: 300
      - maxmem: 600
      - vcpus: 1
      - include_in_backups: False
    - features:
      - set:
        - menu-items: "qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
        - default-menu-items: "qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"

"dvm-{{ template.template }}-absent":
  qvm.absent:
    - names:
      - dvm-{{ template.template_clean }}
      - {{ template.template_clean }}-dvm
      - {{ template.template }}-dvm

"dvm-{{ template.template_clean }}":
  qvm.vm:
    - name: dvm-{{ template.template_clean }}
    - require:
      - sls: {{ template.template_clean }}.clone
    - present:
      - template: {{ template.template }}
      - label: red
    - prefs:
      - template: {{ template.template }}
      - label: red
      - memory: 300
      - maxmem: 400
      - vcpus: 1
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - appmenus-dispvm
      - set:
        - menu-items: "qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"

"{{ slsdotpath }}-set-default_template":
  cmd.run:
    - name: qubes-prefs default_template {{ template.template }}
