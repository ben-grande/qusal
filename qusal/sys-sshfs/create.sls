{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: yellow
prefs:
- template: tpl-{{ slsdotpath }}
- label: yellow
- netvm: ""
- vcpus: 1
- memory: 300
- maxmem: 700
- autostart: False
- include_in_backups: True
features:
- enable:
  - servicevm
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-resize-private-volume":
  cmd.run:
    - name: qvm-volume extend {{ slsdotpath }}:private 40Gi
    - require:
      - qvm: {{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
