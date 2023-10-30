{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - .clone
  - qvm.hide-usb-from-dom0

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
- memory: 0
- maxmem: 400
- vcpus: 1
- virt_mode: hvm
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - servicevm
  - appmenus-dispvm
- disable:
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
  - service.qubes-updates-proxy
{%- endload %}
{{ load(defaults) }}

## TODO: fix _modules/ext_module_qvm.py
{% set usb_pcidevs = salt['grains.get']('pci_usb_devs', []) -%}
{% if usb_pcidevs == ['00:14.0', '00:1a.0', '00:1d.0'] -%}
  {% set usb_host_model = 'T430' -%}
  {% set usbs = ['sys-usb', 'sys-usb-dock', 'sys-usb-left'] -%}
{% else -%}
  {% set usb_host_model = 'unknown' -%}
  {% set usbs = ['sys-usb'] -%}
{% endif -%}

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
- memory: 0
- maxmem: 400
- include_in_backups: False
- pci_strictreset: False
## TODO: remove this "complex" jinja from yaml and use a best practice
{% if usb_host_model == 'T430' -%}
- autostart: False
{% if usb == 'sys-usb-left' -%}
- pcidevs: {{ usb_pcidevs[0]|yaml }}
{% elif usb == 'sys-usb' -%}
- pcidevs: {{ usb_pcidevs[1]|yaml }}
{% elif usb == 'sys-usb-dock' -%}
- pcidevs: {{ usb_pcidevs[2]|yaml }}
{% endif -%}
{% else -%}
- autostart: True
- pcidevs: {{ usb_pcidevs|yaml }}
{% endif -%}
features:
- enable:
  - servicevm
- disable:
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
  - service.qubes-updates-proxy
{%- endload %}
{{ load(defaults) }}
{% endfor -%}
