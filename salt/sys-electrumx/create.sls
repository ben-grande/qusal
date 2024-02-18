{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

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
  - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: blue
prefs:
- template: tpl-{{ slsdotpath }}
- label: blue
- netvm: ""
- audiovm: ""
- vcpus: 4
- memory: 400
- maxmem: 5000
- autostart: False
- include_in_backups: True
features:
- enable:
  - servicevm
  - service.bitcoin-client
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
tags:
- add:
  - "bitcoin-client"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: tpl-electrumx-builder
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
name: dvm-electrumx-builder
force: True
require:
- qvm: tpl-electrumx-builder
present:
- template: tpl-electrumx-builder
- label: red
prefs:
- template: tpl-electrumx-builder
- label: red
- netvm: sys-bitcoin-gateway
- audiovm: ""
- vcpus: 1
- memory: 400
- maxmem: 600
- autostart: False
- template_for_dispvms: True
- include_in_backups: False
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
name: disp-electrumx-builder
force: True
require:
- qvm: dvm-electrumx-builder
present:
- template: dvm-electrumx-builder
- label: red
- class: DispVM
prefs:
- template: dvm-electrumx-builder
- label: red
- netvm: sys-bitcoin-gateway
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
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
tags:
- add:
  - "anon-bitcoin-vm"
- del:
  - "anon-vm"
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-extend-private-volume":
  cmd.run:
    - name: qvm-volume extend {{ slsdotpath }}:private 200Gi

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
