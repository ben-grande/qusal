{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import "whonix-gateway/template.jinja" as whonix_gateway %}

include:
  - .clone

{% load_yaml as defaults -%}
name: {{ slsdotpath }}-gateway
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: {{ whonix_gateway.template }}
- label: orange
prefs:
- template: {{ whonix_gateway.template }}
- label: orange
- audiovm: ""
- default_dispvm: ""
- vcpus: 1
- memory: 300
- maxmem: 500
- provides-network: True
- include_in_backups: True
- autostart: False
features:
- enable:
  - servicevm
- disable:
  - service.cups
  - service.cups-browsed
tags:
- add:
  - "anon-bitcoin-gateway"
- del:
  - "anon-gateway"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
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
name: {{ slsdotpath }}
force: True
require:
- qvm: tpl-{{ slsdotpath }}
present:
- template: tpl-{{ slsdotpath }}
- label: yellow
prefs:
- template: tpl-{{ slsdotpath }}
- label: yellow
- netvm: {{ slsdotpath }}-gateway
- audiovm: ""
- default_dispvm: ""
- vcpus: 4
- memory: 400
- maxmem: 2500
- autostart: False
- include_in_backups: True
features:
- enable:
  - servicevm
  - service.bitcoin-server
- disable:
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
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
name: dvm-bitcoin-builder
force: True
require:
- qvm: tpl-{{ slsdotpath }}
present:
- template: tpl-{{ slsdotpath }}
- label: red
prefs:
- template: tpl-{{ slsdotpath }}
- label: red
- netvm: {{ slsdotpath }}-gateway
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
name: disp-bitcoin-builder
force: True
require:
- qvm: dvm-bitcoin-builder
present:
- template: dvm-bitcoin-builder
- label: red
- class: DispVM
prefs:
- template: dvm-bitcoin-builder
- label: red
- netvm: {{ slsdotpath }}-gateway
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

{% load_yaml as defaults -%}
name: dvm-bitcoin
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
- default_dispvm: ""
- vcpus: 4
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
  - menu-items: "bitcoin-qt.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
tags:
- del:
  - "bitcoin-client"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-bitcoin
force: True
require:
- qvm: dvm-bitcoin
present:
- template: dvm-bitcoin
- label: gray
- class: DispVM
prefs:
- template: dvm-bitcoin
- label: gray
- netvm: ""
- audiovm: ""
- default_dispvm: ""
- vcpus: 4
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
  - menu-items: "bitcoin-qt.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
tags:
- del:
  - "bitcoin-client"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: bitcoin
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
- default_dispvm: ""
- vcpus: 4
- memory: 400
- maxmem: 600
- autostart: False
- include_in_backups: True
features:
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "bitcoin-qt.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop qubes-start.desktop"
tags:
- del:
  - "bitcoin-client"
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-extend-private-volume":
  cmd.run:
    - require:
      - qvm: {{ slsdotpath }}
    - name: qvm-volume extend {{ slsdotpath }}:private 1024Gi

"{{ slsdotpath }}-extend-builder-private-volume":
  cmd.run:
    - require:
      - qvm: dvm-bitcoin-builder
    - name: qvm-volume extend dvm-bitcoin-builder:private 20Gi

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '45') }}
{% from 'utils/macros/policy.sls' import policy_unset with context -%}
{{ policy_unset(sls_path, '70') }}
