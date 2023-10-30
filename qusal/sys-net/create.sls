{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

{% set net_pcidevs = salt['grains.get']('pci_net_devs', []) -%}

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
- memory: 0
- maxmem: 400
- vcpus: 1
- virt_mode: hvm
- autostart: False
- provides-network: True
# - pcidevs: [ '03:00.0', '00:19.0' ]
- pcidevs: {{ net_pcidevs|yaml }}
- pci_strictreset: False
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.qubes-updates-proxy
  - service.clocksync
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
- memory: 0
- maxmem: 400
- vcpus: 1
- virt_mode: hvm
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.qubes-updates-proxy
  - service.clocksync
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
- autostart: False
- provides-network: True
# - pcidevs: [ '03:00.0', '00:19.0' ]
- pcidevs: {{ net_pcidevs|yaml }}
- pci_strictreset: False
- include_in_backups: False
features:
- enable:
  - servicevm
  - service.qubes-updates-proxy
  - service.clocksync
- disable:
  - appmenus-dispvm
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
{%- endload %}
{{ load(defaults) }}
