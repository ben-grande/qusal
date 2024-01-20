{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - .clone
  - qvm.anon-whonix

{% load_yaml as defaults -%}
name: {{ template.whonix_workstation_template }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ template.whonix_gateway_template }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: sys-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: {{ template.whonix_gateway_template }}
- label: black
prefs:
- template: {{ template.whonix_gateway_template }}
- label: black
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 500
- include_in_backups: False
- autostart: False
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: anon-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: {{ template.whonix_workstation_template }}
- label: red
prefs:
- template: {{ template.whonix_workstation_template }}
- label: red
- netvm: sys-{{ slsdotpath }}
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 1500
- include_in_backups: False
- autostart: False
{%- endload %}
{{ load(defaults) }}
