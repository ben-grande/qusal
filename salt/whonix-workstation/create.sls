{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - .clone
  - whonix-gateway.create

{% load_yaml as defaults -%}
name: {{ template.template }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 1500
- include_in_backups: False
features:
- enable:
  - whonix-ws
tags:
- add:
  - whonix-updatevm
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ template.clean_template }}
force: True
require:
- sls: whonix-gateway.create
present:
- template: {{ template.template }}
- label: red
prefs:
- template: {{ template.template }}
- label: red
- netvm: sys-whonix
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
tags:
- add:
  - anon-vm
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: anon-whonix
force: True
require:
- sls: {{ slsdotpath }}.clone
- sls: whonix-gateway.create
present:
- template: {{ template.template }}
- label: red
prefs:
- template: {{ template.template }}
- label: red
- netvm: sys-whonix
- audiovm: ""
- default_dispvm: dvm-{{ template.clean_template }}
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

"{{ template.template }}-default_dispvm":
  qvm.vm:
    - require:
      - qvm: dvm-{{ template.clean_template }}
    - name: {{ template.template }}
    - prefs:
      - default_dispvm: dvm-{{ template.clean_template }}
