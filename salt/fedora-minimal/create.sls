{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - fedora.create
  - .clone

"dvm-{{ template.template }}-absent":
  qvm.absent:
    - names:
      - {{ template.template_clean }}-dvm
      - {{ template.template }}-dvm

{% load_yaml as defaults -%}
name: {{ template.template }}
force: True
require:
- sls: {{ template.template_clean }}.clone
present:
- label: black
prefs:
- label: black
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 600
- include_in_backups: False
features:
- set:
  - menu-items: "qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
  - default-menu-items: "qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ template.template_clean }}
force: True
require:
- sls: {{ template.template_clean }}.clone
present:
- template: {{ template.template }}
- label: red
prefs:
- template: {{ template.template }}
- label: red
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 400
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
- set:
  - menu-items: "qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-set-management_dispvm-to-dvm-fedora":
  qvm.vm:
    - require:
      - qvm: dvm-fedora
    - name: {{ template.template }}
    - prefs:
      - management_dispvm: dvm-fedora

## TODO: Remove when template with patch reaches upstream or updates enforce
## salt-deps to be installed.
## https://github.com/QubesOS/qubes-issues/issues/8806
"{{ slsdotpath }}-install-salt-deps":
  cmd.script:
    - require:
      - qvm: "{{ slsdotpath }}-set-management_dispvm-to-dvm-fedora"
    - name: salt-patch.sh
    - source: salt://fedora-minimal/files/admin/bin/salt-patch.sh
    - args: {{ template.template }}
