{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

{%- from "qvm/template.jinja" import load -%}

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
- netvm: ""
- vpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: True
features:
- enable:
  - service.split-gpg2-client
  - service.crond
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: red
prefs:
- template: tpl-{{ slsdotpath }}
- label: red
- netvm: ""
- vpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-{{ slsdotpath }}
force: True
require:
- qvm: dvm-{{ slsdotpath }}
present:
- template: dvm-{{ slsdotpath }}
- label: red
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}
- label: red
- vpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: False
features:
- disable:
  - appmenus-dispvm
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}
