{%- import "templates/fedora.jinja" as template -%}

include:
  - templates.{{ template.template_clean }}.clone

"{{ template.template_clean }}":
  qvm.vm:
    - name: {{ template.template_clean }}
    - require:
      - sls: templates.{{ template.template_clean }}.clone
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
      - dvm-fedora
      - fedora-dvm
      - {{ template.template }}-dvm

"dvm-{{ template.template_clean }}":
  qvm.vm:
    - name: dvm-{{ template.template_clean }}
    - require:
      - sls: templates.{{ template.template_clean }}.clone
    - present:
      - template: {{ fedora.fedora_template }}
      - label: red
    - prefs:
      - template: {{ fedora.fedora_template }}
      - label: red
      - memory: 300
      - maxmem: 400
      - vcpus: 1
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - appmenus-dispvm
