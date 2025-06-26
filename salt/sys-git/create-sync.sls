{#
SPDX-FileCopyrightText: 2025 The Qusal Community <https://github.com/ben-grande/qusal>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - {{ slsdotpath }}.clone

{# TODO: make this properly read configuration from pillar instead of inlined in code #}
{# % set syncs = [
  {
    'name': 'example',
    'memory': 500,
    'maxmem': 700,
    'vcpus': 1,
  },
] - #%}

{% if syncs is defined and syncs %}
{% for vm in syncs -%}
{% set prefix = slsdotpath ~ "-" ~ vm.name %}
{% load_yaml as defaults -%}
name: {{ prefix }}-sync
force: True
require:
- qvm: tpl-{{ slsdotpath }}-sync
present:
- template: tpl-{{ slsdotpath }}-sync
- label: red
prefs:
- template: tpl-{{ slsdotpath }}-sync
- label: red
- audiovm: ""
- vcpus: 1
- memory: 200
- maxmem: 350
- include_in_backups: False
features:
- enable:
  - servicevm
  # - service.split-gpg2-client
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
- set:
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
tags:
- add:
  - "git-sync"

{%- endload %}
{{ load(defaults) }}
{% endfor %}
{% endif -%}
