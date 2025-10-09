{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - {{ slsdotpath }}.clone

{% load_yaml as defaults -%}
name: {{ template.template }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
- default_dispvm: ""
- vcpus: 1
- memory: 300
- maxmem: 600
- include_in_backups: False
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ template.clean_template }}
force: True
require:
- qvm: {{ template.template }}
present:
- template: {{ template.template }}
- label: red
prefs:
- template: {{ template.template }}
- label: red
- audiovm: ""
- default_dispvm: dvm-{{ template.clean_template }}
- vcpus: 1
- memory: 300
- maxmem: 1500
- template_for_dispvms: True
- include_in_backups: False
- autostart: False
features:
- enable:
  - appmenus-dispvm
{%- endload %}
{{ load(defaults) }}
