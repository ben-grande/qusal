{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
features:
- set:
  - menu-items: "mutt.desktop qubes-run-terminal.desktop qubes-start.desktop"
  - default-menu-items: "mutt.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: yellow
prefs:
- template: tpl-{{ slsdotpath }}
- label: yellow
- vpus: 1
- memory: 200
- maxmem: 350
- autostart: False
features:
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}
