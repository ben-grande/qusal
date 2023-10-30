{#
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
- label: gray
prefs:
- template: tpl-{{ slsdotpath }}
- label: gray
- memory: 300
- maxmem: 600
- vcpus: 1
- provides-network: true
features:
- enable:
  - servicevm
  - service.shutdown-idle
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '75') }}

"{{ slsdotpath }}-extend-volume":
  cmd.run:
    - name: qvm-volume extend {{ slsdotpath }}:private 20Gi
    - require:
      - qvm: {{ slsdotpath }}
