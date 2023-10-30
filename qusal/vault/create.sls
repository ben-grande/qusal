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