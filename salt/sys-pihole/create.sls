{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
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
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 400
- netvm: {{ netvm }}
- provides-network: true
features:
- enable:
  - servicevm
  - service.qubes-firewall
  - service.clocksync
- disable:
  - service.cups
  - service.cups-browsed
  - service.tracker
  - service.evolution-data-server
  - service.updates-proxy-setup
- set:
  - menu-items: "pihole-browser.desktop qubes-run-terminal.desktop qubes-start.desktop"
tags:
- del:
  - updatevm-sys-cacher
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
- template: tpl-browser
- label: orange
- netvm: ""
- audiovm: ""
- vcpus: 1
- memory: 300
- maxmem: 600
- include_in_backups: False
features:
- enable:
  - service.http-client
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
