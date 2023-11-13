{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

# Use the netvm of the default_netvm.
{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
{% set netvm = salt['cmd.shell']('qvm-prefs ' + default_netvm + ' netvm') -%}
# If netvm is empty, user's default_netvm is the uplink (sys-net).
{% if netvm == '' %}
  {% set netvm = default_netvm %}
{% endif -%}

include:
  - .clone

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
- maxmem: 400
- netvm: {{ netvm }}
- vcpus: 1
- provides-network: True
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.qubes-firewall
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
- label: orange
prefs:
- template: tpl-{{ slsdotpath }}
- label: orange
- netvm: {{ netvm }}
- memory: 300
- maxmem: 400
- vcpus: 1
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - servicevm
- disable:
  - appmenus-dispvm
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
- label: orange
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}
- label: orange
- netvm: {{ netvm }}
- memory: 300
- maxmem: 400
- vcpus: 1
- provides-network: True
- autostart: False
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.qubes-firewall
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}
