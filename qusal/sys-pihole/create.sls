{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import "debian-minimal/template.jinja" as template -%}

{# Use the netvm of the default_netvm. #}
{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
{% set netvm = salt['cmd.shell']('qvm-prefs ' + default_netvm + ' netvm') -%}
{#
If netvm of default_netvm is empty, user's default_netvm is the first in
the chain (sys-net).
#}
{% if netvm == '' %}
  {% set netvm = default_netvm %}
{% endif %}

include:
  - debian-minimal.create
  - browser.create

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ template.template_clean }}.create
present:
- template: {{ template.template }}
- label: orange
- class: StandaloneVM
prefs:
- label: orange
- memory: 300
- maxmem: 400
- vcpus: 1
- netvm: {{ netvm }}
- provides-network: true
features:
- enable:
  - servicevm
  - service.updates-proxy-setup
  - service.qubes-firewall
- disable:
  - service.cups
  - service.cups-browsed
  - service.tracker
  - service.evolution-data-server
- set:
  - menu-items: "pihole-browser.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}-browser
force: True
require:
- sls: browser.create
present:
- template: tpl-browser
- label: orange
prefs:
- label: orange
- memory: 300
- maxmem: 600
- vcpus: 1
- netvm: ""
- include_in_backups: False
features:
- disable:
  - service.cups
  - service.cups-browsed
  - service.tracker
  - service.evolution-data-server
- set:
  - menu-items: "pihole-browser.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-resize-private-volume":
  cmd.run:
    - name: qvm-volume resize {{ slsdotpath }}:private 20Gi
    - require:
      - qvm: {{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
