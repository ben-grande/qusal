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
- audiovm: ""
- netvm: ""
- vcpus: 4
- memory: 400
- maxmem: 3000
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
name: tpl-electrs-builder
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
## See comment in clone.sls.
{% if salt['cmd.shell']('qvm-features tpl-electrs-builder whonix-ws') == '1' %}
tags:
- add:
  - "updatevm-sys-bitcoin-gateway"
- del:
  - "whonix-updatevm"
{% endif %}
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-electrs-builder
force: True
require:
- qvm: tpl-electrs-builder
present:
- template: tpl-electrs-builder
- label: red
prefs:
- template: tpl-electrs-builder
- label: red
## See comment in clone.sls.
{% if salt['cmd.shell']('qvm-features tpl-electrs-builder whonix-ws') == '1' %}
- netvm: sys-bitcoin-gateway
{% else %}
- netvm: "*default*"
{% endif %}
- audiovm: ""
- vcpus: 4
- memory: 400
- maxmem: 800
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
name: disp-electrs-builder
force: True
require:
- qvm: dvm-electrs-builder
present:
- template: dvm-electrs-builder
- label: red
- class: DispVM
prefs:
- template: dvm-electrs-builder
- label: red
## See comment in clone.sls.
{% if salt['cmd.shell']('qvm-features tpl-electrs-builder whonix-ws') == '1' %}
- netvm: sys-bitcoin-gateway
{% else %}
- netvm: "*default*"
{% endif %}
- audiovm: ""
- vcpus: 4
- memory: 400
- maxmem: 800
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
    - require:
      - qvm: {{ slsdotpath }}
    - name: qvm-volume extend {{ slsdotpath }}:private 200Gi

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
