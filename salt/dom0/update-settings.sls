{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}
{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
features:
- set:
  - qubes-vm-update-if-stale: 4
  - qubes-vm-update-max-concurrency: 4
  - qubes-vm-update-restart-system: 1
  - qubes-vm-update-restart-other: 0
{%- endload %}
{{ load(defaults) }}

{% endif -%}
