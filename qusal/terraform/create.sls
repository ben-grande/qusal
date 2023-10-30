{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

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
- vpus: 1
- memory: 400
- maxmem: 600
- autostart: False
features:
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}
