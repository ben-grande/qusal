{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - {{ slsdotpath }}.clone
  - utils.tools.common.update
  - qvm.hide-usb-from-dom0
  {% if salt['pillar.get']('qvm:sys-usb:keyboard-action', 'deny') == 'allow' %}
  - qvm.sys-usb-prioritize-autostart
  {% endif %}

"{{ slsdotpath }}-installed-dom0":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-input-proxy

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
features:
- set:
  # editorconfig-checker-disable
  - default-menu-items: "com.github.wwmm.easyeffects.desktop pavucontrol.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop" # noqa: 204
  - menu-items: "com.github.wwmm.easyeffects.desktop pavucontrol.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop" # noqa: 204
  # editorconfig-checker-enable
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
  - service.minimal-usbvm
  - appmenus-dispvm
- disable:
  - service.network-manager
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
  - service.qubes-updates-proxy
- set:
  # editorconfig-checker-disable
  - menu-items: "com.github.wwmm.easyeffects.desktop pavucontrol.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop" # noqa: 204
  # editorconfig-checker-enable
{%- endload %}
{{ load(defaults) }}

{% set usb_pcidevs = salt['grains.get']('pci_usb_devs', []) -%}
{% if usb_pcidevs == ['00:14.0', '00:1a.0', '00:1d.0'] -%}
  {% set usb_host_model = 'ThinkPad T430' -%}
  {% set usbs = ['disp-sys-usb', 'disp-sys-usb-dock', 'disp-sys-usb-left'] -%}
{% else -%}
  {% set usb_host_model = 'unknown' -%}
  {% set usbs = ['disp-sys-usb'] -%}
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
      'qubes': ['disp-sys-usb', 'disp-sys-usb-dock', 'disp-sys-usb-left'],
      'pcidevs': ['00:14.0', '00:1a.0', '00:1d.0'],
      'autostart': False,
    },
    'UNCATEGORIZED': {
      'qubes': ['disp-sys-usb'],
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
- audiovm: ""
- memory: 400
- maxmem: 0
- include_in_backups: False
- pci_strictreset: False
{% if usb_host_model == 'ThinkPad T430' -%}
- autostart: False
{% if usb == 'disp-sys-usb-left' -%}
- pcidevs: {{ [usb_pcidevs[0]]|yaml }}
{% elif usb == 'disp-sys-usb' -%}
- pcidevs: {{ [usb_pcidevs[1]]|yaml }}
{% elif usb == 'disp-sys-usb-dock' -%}
- pcidevs: {{ [usb_pcidevs[2]]|yaml }}
{% endif -%}
{% else -%}
- autostart: True
- pcidevs: {{ usb_pcidevs|yaml }}
{% endif -%}
features:
- enable:
  - servicevm
  - service.minimal-usbvm
- disable:
  - service.network-manager
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
  - service.qubes-updates-proxy
- set:
  # editorconfig-checker-disable
  - menu-items: "com.github.wwmm.easyeffects.desktop pavucontrol.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop" # noqa: 204
  # editorconfig-checker-enable
tags:
- add:
  - usbvm
{%- endload %}
{{ load(defaults) }}
{% endfor -%}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
