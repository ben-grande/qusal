{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - .clone

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
features:
- enable:
  - whonix-gw
tags:
- add:
  - whonix-updatevm
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: sys-whonix
force: True
require:
- sls: {{ slsdotpath }}.clone
- qvm: {{ template.template }}
present:
- template: {{ template.template }}
- label: black
prefs:
- template: {{ template.template }}
- label: black
- audiovm: ""
- default_dispvm: ""
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
