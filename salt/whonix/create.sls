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
- memory: 300
- maxmem: 500
- vcpus: 1
- include_in_backups: False
- autostart: False
{%- endload %}
{{ load(defaults) }}
