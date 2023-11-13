{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - .clone

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
  - sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: orange
prefs:
- template: tpl-{{ slsdotpath }}
- label: orange
- provides-network: True
- vcpus: 1
- memory: 300
- maxmem: 400
- autostart: False
- include_in_backups: False
features:
- enable:
  - servicevm
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}
