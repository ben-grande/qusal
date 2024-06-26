{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{% set net_pcidevs = salt['grains.get']('pci_net_devs', []) -%}

include:
  - .clone
  - .show-updatevm-origin

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
- label: red
prefs:
- template: tpl-{{ slsdotpath }}
- label: red
- netvm: ""
- audiovm: ""
- memory: 400
- maxmem: 0
- vcpus: 1
- virt_mode: hvm
- autostart: False
- provides-network: True
- pcidevs: {{ net_pcidevs|yaml }}
- pci_strictreset: False
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.qubes-updates-proxy
- disable:
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
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
- audiovm: ""
- memory: 400
- maxmem: 0
- vcpus: 1
- virt_mode: hvm
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.qubes-updates-proxy
- disable:
  - appmenus-dispvm
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
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
- netvm: ""
- audiovm: ""
- autostart: False
- provides-network: True
- pcidevs: {{ net_pcidevs|yaml }}
- pci_strictreset: False
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.qubes-updates-proxy
- disable:
  - appmenus-dispvm
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
{%- endload %}
{{ load(defaults) }}
