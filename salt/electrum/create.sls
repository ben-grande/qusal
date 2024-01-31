{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import "whonix/template.jinja" as whonix -%}

include:
  - .clone
  - whonix.create

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
features:
- set:
  - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop electrum.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}-cold
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: gray
prefs:
- template: tpl-{{ slsdotpath }}
- label: gray
- netvm: ""
- audiovm: ""
- vcpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: True
features:
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop electrum.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}-hot
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: {{ whonix.whonix_workstation_template }}
- label: orange
prefs:
- template: {{ whonix.whonix_workstation_template }}
- label: orange
- audiovm: ""
- vcpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: True
tags:
- add:
  - anon-vm
features:
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop qubes-open-file-manager.desktop electrum.desktop"
{%- endload %}
{{ load(defaults) }}
