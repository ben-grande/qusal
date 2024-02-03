{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

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
- virt_mode: hvm
- kernel: ""
{%- endload %}
{{ load(defaults) }}
