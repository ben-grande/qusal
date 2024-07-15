{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}
{%- from "qvm/template.jinja" import load -%}

include:
  - .clone

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
  - appmenus-dispvm
- disable:
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

{% set audio_pcidevs = salt['grains.get']('pci_audio_devs', []) %}
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
- audiovm: disp-{{ slsdotpath }}
- include_in_backups: False
- pci_strictreset: False
- autostart: False
- pcidevs: {{ audio_pcidevs|yaml }}
features:
- enable:
  - servicevm
  - service.audiovm
  - service.blueman
- disable:
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
  - audiovm
{%- endload %}
{{ load(defaults) }}

"disp-{{ slsdotpath }}-default_audiovm":
  cmd.run:
    - require:
      - qvm: disp-{{ slsdotpath }}
    - name: qubes-prefs default_audiovm disp-{{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
