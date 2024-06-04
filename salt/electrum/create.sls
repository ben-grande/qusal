{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import "whonix-workstation/template.jinja" as whonix_workstation -%}

include:
  - .clone
  - sys-bitcoin.create

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
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}-builder
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
- default_dispvm: ""
features:
- set:
  - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
tags:
- add:
  - "updatevm-sys-bitcoin-gateway"
- del:
  - "whonix-updatevm"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}
force: True
require:
- qvm: tpl-{{ slsdotpath }}
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
- include_in_backups: False
- template_for_dispvms: True
features:
- enable:
  - appmenus-dispvm
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop qubes-open-file-manager.desktop electrum.desktop"
tags:
- add:
  - "electrum-client"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-{{ slsdotpath }}
force: True
require:
- qvm: dvm-{{ slsdotpath }}
present:
- template: dvm-{{ slsdotpath }}
- label: gray
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}
- label: gray
- netvm: ""
- audiovm: ""
- vcpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: False
features:
- disable:
  - appmenus-dispvm
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop qubes-open-file-manager.desktop electrum.desktop"
tags:
- add:
  - "electrum-client"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- qvm: tpl-{{ slsdotpath }}
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
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop qubes-open-file-manager.desktop electrum.desktop"
tags:
- add:
  - "electrum-client"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}-hot
force: True
require:
- qvm: {{ whonix_workstation.template }}
present:
- template: {{ whonix_workstation.template }}
- label: orange
prefs:
- template: {{ whonix_workstation.template }}
- label: orange
- audiovm: ""
- netvm: sys-bitcoin-gateway
- vcpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: True
- template_for_dispvms: True
features:
- enable:
  - appmenus-dispvm
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop qubes-open-file-manager.desktop electrum.desktop"
tags:
- add:
  - "anon-vm"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-{{ slsdotpath }}-hot
force: True
require:
- qvm: dvm-{{ slsdotpath }}-hot
present:
- template: dvm-{{ slsdotpath }}-hot
- label: orange
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}-hot
- label: orange
- audiovm: ""
- netvm: sys-bitcoin-gateway
- vcpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: True
features:
- disable:
  - appmenus-dispvm
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop qubes-open-file-manager.desktop electrum.desktop"
tags:
- add:
  - "anon-vm"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}-hot
force: True
require:
- qvm: {{ whonix_workstation.template }}
present:
- template: {{ whonix_workstation.template }}
- label: orange
prefs:
- template: {{ whonix_workstation.template }}
- label: orange
- audiovm: ""
- netvm: sys-bitcoin-gateway
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
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop qubes-open-file-manager.desktop electrum.desktop"
tags:
- add:
  - "anon-vm"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-electrum-builder
force: True
require:
- qvm: tpl-electrum-builder
present:
- template: tpl-electrum-builder
- label: red
prefs:
- template: tpl-electrum-builder
- label: red
- netvm: sys-bitcoin-gateway
- audiovm: ""
- default_dispvm: ""
- vcpus: 4
- memory: 400
- maxmem: 2000
- autostart: False
- template_for_dispvms: True
features:
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
tags:
- add:
  - "anon-bitcoin-vm"
- del:
  - "anon-vm"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-electrum-builder
force: True
require:
- qvm: dvm-electrum-builder
present:
- template: dvm-electrum-builder
- label: red
- class: DispVM
prefs:
- template: dvm-electrum-builder
- label: red
- netvm: sys-bitcoin-gateway
- audiovm: ""
- vcpus: 4
- memory: 400
- maxmem: 2000
- autostart: False
- include_in_backups: False
features:
- disable:
  - appmenus-dispvm
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
tags:
- add:
  - "anon-bitcoin-vm"
- del:
  - "anon-vm"
{%- endload %}
{{ load(defaults) }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
