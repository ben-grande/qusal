{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - .clone

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: gray
prefs:
- template: tpl-{{ slsdotpath }}
- label: gray
- audiovm: ""
- vcpus: 2
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: True
features:
- enable:
  - service.docker
  - service.podman
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: red
prefs:
- template: tpl-{{ slsdotpath }}
- label: red
- audiovm: ""
- vcpus: 2
- memory: 400
- maxmem: 600
- autostart: False
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-{{ slsdotpath }}
force: True
require:
- qvm: dvm-{{ slsdotpath }}
present:
- template: dvm-{{ slsdotpath }}
- label: red
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}
- label: red
- audiovm: ""
- vcpus: 2
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: False
features:
- disable:
  - appmenus-dispvm
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-extend-volume":
  cmd.run:
    - name: qvm-volume extend {{ slsdotpath }}:private 10Gi
    - require:
      - qvm: {{ slsdotpath }}
