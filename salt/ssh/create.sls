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
- label: purple
prefs:
- template: tpl-{{ slsdotpath }}
- label: purple
- audiovm: ""
- vcpus: 1
- memory: 400
- maxmem: 500
- autostart: False
features:
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: purple
prefs:
- template: tpl-{{ slsdotpath }}
- label: purple
- audiovm: ""
- vcpus: 1
- memory: 400
- maxmem: 500
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
