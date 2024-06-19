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
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
  - sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: orange
prefs:
- template: tpl-{{ slsdotpath }}
- label: orange
- audiovm: ""
- provides-network: True
- vcpus: 1
- memory: 300
- maxmem: 400
- autostart: False
- include_in_backups: False
features:
- enable:
  - servicevm
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-qvm-wireguard":
  file.managed:
    - name: /usr/local/bin/qvm-wireguard
    - source: salt://{{ slsdotpath }}/files/admin/bin/qvm-wireguard
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True
