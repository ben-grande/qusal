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
prefs:
- memory: 300
- maxmem: 400
features:
- set:
  - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

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
- netvm: ""
- vpus: 1
- memory: 400
- maxmem: 500
- autostart: False
- include_in_backups: True
features:
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}-minion
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: purple
prefs:
- template: tpl-{{ slsdotpath }}
- label: purple
- netvm: ""
- vpus: 1
- memory: 400
- maxmem: 500
- autostart: False
- include_in_backups: True
features:
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
