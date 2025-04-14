{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - {{ slsdotpath }}.clone
  - mgmt.create

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
- sls: mgmt.create
prefs:
- audiovm: ""
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
- audiovm: ""
- vcpus: 4
- memory: 400
- maxmem: 4000
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
- audiovm: ""
- memory: 400
- maxmem: 1000
- vcpus: 1
- default_dispvm: dvm-{{ slsdotpath }}
features:
- enable:
  - service.docker
  - service.podman
  - service.split-gpg2-client
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
