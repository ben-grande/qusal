{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}
{%- from "qvm/template.jinja" import load -%}

include:
  - .clone

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
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
  - service.qubes-updates-proxy
{%- endload %}
{{ load(defaults) }}

{% set audio_pcidevs = salt['grains.get']('pci_audio_devs', []) -%}
{% load_yaml as defaults -%}
name: {{ slsdotpath }}
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
- include_in_backups: False
- pci_strictreset: False
- autostart: False
- pcidevs: {{ audio_pcidevs|yaml }}
features:
- enable:
  - servicevm
  - service.audiovm
- disable:
  - service.cups
  - service.cups-browsed
  - service.meminfo-writer
  - service.qubes-updates-proxy
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-default_audiovm":
  cmd.run:
    - require:
      - qvm: {{ slsdotpath }}
    - name: qubes-prefs default_audiovm {{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
