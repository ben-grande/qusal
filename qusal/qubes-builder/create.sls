{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

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
- vpus: 2
- memory: 400
- maxmem: 2000
- autostart: False
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

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
- memory: 800
- maxmem: 8000
- vcpus: 4
- default_dispvm: dvm-{{ slsdotpath }}
features:
# - enable:
#   - service.split-gpg2-client
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-extend-private-volume":
  cmd.run:
    - name: qvm-volume extend {{ slsdotpath }}:private 30Gi
    - require:
      - qvm: {{ slsdotpath }}

"dvm-{{ slsdotpath }}-extend-private-volume":
  cmd.run:
    - name: qvm-volume extend dvm-{{ slsdotpath }}:private 30Gi
    - require:
      - qvm: dvm-{{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '70') }}
