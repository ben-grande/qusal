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
features:
- set:
  - menu-items: "org.keepassxc.KeePassXC.desktop qubes-run-terminal.desktop qubes-start.desktop"
  - default-menu-items: "org.keepassxc.KeePassXC.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: black
prefs:
- template: tpl-{{ slsdotpath }}
- label: black
- netvm: ""
- audiovm: ""
- memory: 400
- maxmem: 600
- vcpus: 1
- autostart: False
- include_in_backups: True
features:
- set:
  - menu-items: "org.keepassxc.KeePassXC.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}
