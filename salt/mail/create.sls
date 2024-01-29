{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - .clone

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}-fetcher
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}-reader
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
features:
- set:
  - menu-items: "mutt.desktop qubes-run-terminal.desktop qubes-start.desktop"
  - default-menu-items: "mutt.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}-sender
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}-fetcher
force: True
require:
- qvm: tpl-{{ slsdotpath }}-fetcher
present:
- template: tpl-{{ slsdotpath }}-fetcher
- label: red
prefs:
- template: tpl-{{ slsdotpath }}-fetcher
- label: red
- audiovm: ""
- vcpus: 1
- memory: 200
- maxmem: 350
- template_for_dispvms: True
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

{% load_yaml as defaults -%}
name: {{ slsdotpath }}-reader
force: True
require:
- qvm: tpl-{{ slsdotpath }}-reader
present:
- template: tpl-{{ slsdotpath }}-reader
- label: red
prefs:
- template: tpl-{{ slsdotpath }}-fetcher
- label: red
- audiovm: ""
- vcpus: 1
- memory: 200
- maxmem: 350
- include_in_backups: False
features:
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}-sender
force: True
require:
- qvm: tpl-{{ slsdotpath }}-sender
present:
- template: tpl-{{ slsdotpath }}-sender
- label: red
prefs:
- template: tpl-{{ slsdotpath }}-sender
- label: red
- audiovm: ""
- vcpus: 1
- memory: 200
- maxmem: 350
- template_for_dispvms: True
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

{% load_yaml as defaults -%}
name: disp-{{ slsdotpath }}-fetcher
force: True
require:
- qvm: dvm-{{ slsdotpath }}-fetcher
present:
- template: dvm-{{ slsdotpath }}-fetcher
- label: red
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}-fetcher
- label: red
- audiovm: ""
- vcpus: 1
- memory: 200
- maxmem: 350
- autostart: False
features:
- enable:
  - servicevm
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-{{ slsdotpath }}-sender
force: True
require:
- qvm: dvm-{{ slsdotpath }}-sender
present:
- template: dvm-{{ slsdotpath }}-sender
- label: red
- class: DispVM
prefs:
- template: dvm-{{ slsdotpath }}-sender
- label: red
- audiovm: ""
- vcpus: 1
- memory: 200
- maxmem: 350
- autostart: False
features:
- enable:
  - servicevm
- disable:
  - service.cups
  - service.cups-browsed
  - service.tinyproxy
{%- endload %}
{{ load(defaults) }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
