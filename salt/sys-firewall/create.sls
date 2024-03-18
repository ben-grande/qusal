{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

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
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
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
- audiovm: ""
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
  - service.clocksync
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
- audiovm: ""
- memory: 300
- maxmem: 400
- vcpus: 1
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.clocksync
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
- audiovm: ""
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
  - service.clocksync
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

## Anticipate network usage as sys-firewall is turned off at this step.
## Starting the machine before let's the network be established with enough
## time for the package installation in the template to work.
{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
{% if default_netvm -%}
"{{ slsdotpath }}-start-{{ default_netvm }}-anticipate-network-use":
  qvm.start:
    - name: {{ default_netvm }}
{% endif -%}

{% set template_updatevm = salt['cmd.shell']("qrexec-policy tpl-sys-firewall @default qubes.UpdatesProxy 2>/dev/null | awk -F '=' '/^target=/{print $2}'") -%}
{% if template_updatevm -%}
"{{ slsdotpath }}-start-{{ template_updatevm }}-antecipate-network-use":
  qvm.start:
    - name: {{ template_updatevm }}
{% endif -%}
