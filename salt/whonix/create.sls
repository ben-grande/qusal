{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - .clone

{% load_yaml as defaults -%}
name: {{ template.whonix_workstation_template }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 1500
- include_in_backups: False
tags:
- add:
  - whonix-updatevm
features:
- enable:
  - whonix-ws
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ template.whonix_gateway_template }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 600
- include_in_backups: False
tags:
- add:
  - whonix-updatevm
features:
- enable:
  - whonix-gw
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ template.whonix_workstation_clean_template }}
force: True
require:
- qvm: sys-{{ slsdotpath }}
- qvm: anon-{{ slsdotpath }}
present:
- template: {{ template.whonix_workstation_template }}
- label: red
prefs:
- template: {{ template.whonix_workstation_template }}
- label: red
- netvm: sys-{{ slsdotpath }}
- audiovm: ""
- default_dispvm: dvm-{{ template.whonix_workstation_clean_template }}
- vcpus: 1
- memory: 300
- maxmem: 1500
- template_for_dispvms: True
- include_in_backups: False
- autostart: False
features:
- enable:
  - appmenus-dispvm
tags:
- add:
  - anon-vm
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: sys-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
- qvm: {{ template.whonix_gateway_template }}
present:
- template: {{ template.whonix_gateway_template }}
- label: black
prefs:
- template: {{ template.whonix_gateway_template }}
- label: black
- audiovm: ""
- default_dispvm: dvm-{{ template.whonix_workstation_clean_template }}
- vcpus: 1
- memory: 300
- maxmem: 500
- provides-network: True
- include_in_backups: False
- autostart: False
tags:
- add:
  - anon-gateway
{%- endload %}
{{ load(defaults) }}


{% load_yaml as defaults -%}
name: anon-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
- qvm: sys-{{ slsdotpath }}
- qvm: {{ template.whonix_workstation_template }}
present:
- template: {{ template.whonix_workstation_template }}
- label: red
prefs:
- template: {{ template.whonix_workstation_template }}
- label: red
- netvm: sys-{{ slsdotpath }}
- audiovm: ""
- default_dispvm: dvm-{{ template.whonix_workstation_clean_template }}
- vcpus: 1
- memory: 300
- maxmem: 1500
- include_in_backups: False
- autostart: False
tags:
- add:
  - anon-vm
{%- endload %}
{{ load(defaults) }}
