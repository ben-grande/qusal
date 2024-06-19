{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

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
  - default-menu-items: "system-config-printer.desktop simple-scan.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes.start.desktop"
  - menu-items: "system-config-printer.desktop simple-scan.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes.start.desktop"
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
- netvm: "*default*"
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 400
- autostart: False
- template_for_dispvms: True
- include_in_backups: True
features:
- enable:
  - servicevm
  - service.cups
  - appmenus-dispvm
- disable:
  - service.cups-browsed
  - service.tinyproxy
  - service.tracker
  - service.evolution-data-server
- set:
  - menu-items: "system-config-printer.desktop simple-scan.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes.start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: dvm-{{ slsdotpath }}
- label: red
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}
- label: red
- netvm: "*default*"
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 400
- autostart: False
- include_in_backups: True
features:
- enable:
  - servicevm
  - service.cups
- disable:
  - service.cups-browsed
  - service.tinyproxy
  - service.tracker
  - service.evolution-data-server
- set:
  - menu-items: "system-config-printer.desktop simple-scan.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes.start.desktop"
tags:
- add:
  - "print-server"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: red
prefs:
- template: tpl-{{ slsdotpath }}
- label: red
- netvm: "*default*"
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 400
- autostart: False
- include_in_backups: True
features:
- enable:
  - servicevm
  - service.cups
- disable:
  - service.cups-browsed
  - service.tinyproxy
  - service.tracker
  - service.evolution-data-server
- set:
  - menu-items: "system-config-printer.desktop simple-scan.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes.start.desktop"
tags:
- add:
  - "print-server"
{%- endload %}
{{ load(defaults) }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
