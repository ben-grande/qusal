{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - .clone

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
features:
- set:
  - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop org.remmina.Remmina.desktop"
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop org.remmina.Remmina.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: orange
prefs:
- template: tpl-{{ slsdotpath }}
- label: orange
- memory: 300
- maxmem: 600
- vcpus: 1
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop org.remmina.Remmina.desktop"
{%- endload %}
{{ load(defaults) }}

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
- memory: 300
- maxmem: 600
- vcpus: 1
- include_in_backups: False
features:
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop org.remmina.Remmina.desktop"
{%- endload %}
{{ load(defaults) }}
