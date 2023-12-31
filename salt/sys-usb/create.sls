{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - .clone

{#
"{{ slsdotpath }}-updated-dom0":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-install-dom0-package":
  pkg.installed:
    - pkgs:
      - qubes-ctap-dom0
#}

"{{ slsdotpath }}-absent":
  qvm.absent:
    - names:
      - {{ slsdotpath }}
      - sys-usb-dock
      - sys-usb-left
      - dvm-{{ slsdotpath }}

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
- memory: 400
- maxmem: 0
- vcpus: 1
- virt_mode: hvm
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - servicevm
  - appmenus-dispvm
- disable:
  - service.network-manager
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
  - service.qubes-updates-proxy
{%- endload %}
{{ load(defaults) }}

{% set usb_pcidevs = salt['grains.get']('pci_usb_devs', []) -%}
{% if usb_pcidevs == ['00:14.0', '00:1a.0', '00:1d.0'] -%}
  {% set usb_host_model = 'ThinkPad T430' -%}
  {% set usbs = ['sys-usb', 'sys-usb-dock', 'sys-usb-left'] -%}
{% else -%}
  {% set usb_host_model = 'unknown' -%}
  {% set usbs = ['sys-usb'] -%}
{% endif -%}

{#
TODO: salt jinja best practice
Map different usb controlles to different usb qubes.
Problems:
- Random name generator for qubes would be troublesome for the user
  to guess to which qube his usb controller is. Only mapped brands and
  models will work.
Questions:
- How to use jinja array to assign a qube per controller?
- How to assign UNCATEGORIZED to unregistered products?
#}
{#
{% set usb_pcidevs = {
    'ThinkPad T430': {
      'qubes': ['sys-usb', 'sys-usb-dock', 'sys-usb-left'],
      'pcidevs': ['00:14.0', '00:1a.0', '00:1d.0'],
      'autostart': False,
    },
    'UNCATEGORIZED': {
      'qubes': ['sys-usb'],
      'pcidevs': {{ usb_pcidevs }},
      'autostart': True,
    },
}.get(salt['smbios.get']('system-version') -%}

{% for usb in usb_pcidevs.qubes -%}
pcidevs: {{ usb_pcidevs.pcidevs|sequence|yaml }}
autostart: {{ usb_pcidevs.autostart|sequence|yaml }}
{% endfor -%}
#}

{% for usb in usbs -%}
{% load_yaml as defaults -%}
name: {{ usb }}
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
- memory: 400
- maxmem: 0
- include_in_backups: False
- pci_strictreset: False
{% if usb_host_model == 'ThinkPad T430' -%}
- autostart: False
{% if usb == 'sys-usb-left' -%}
- pcidevs: {{ [usb_pcidevs[0]]|yaml }}
{% elif usb == 'sys-usb' -%}
- pcidevs: {{ [usb_pcidevs[1]]|yaml }}
{% elif usb == 'sys-usb-dock' -%}
- pcidevs: {{ [usb_pcidevs[2]]|yaml }}
{% endif -%}
{% else -%}
- autostart: True
- pcidevs: {{ usb_pcidevs|yaml }}
{% endif -%}
features:
- enable:
  - servicevm
- disable:
  - service.network-manager
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
  - service.qubes-updates-proxy
{%- endload %}
{{ load(defaults) }}
{% endfor -%}
