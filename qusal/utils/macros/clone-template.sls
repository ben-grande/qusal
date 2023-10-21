{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{#
Usage:
1: Import this template:
{% from 'utils/macros/clone-template.sls' import clone_template -%}

2: Set template to clone from and the clone name:
{{ clone_template('debian-minimal', sls_path) }}
#}

{% macro clone_template(source, name) -%}

{%- import source ~ "/template.jinja" as template -%}

include:
  - {{ source }}.create

"tpl-{{ name }}-clone":
  qvm.clone:
    - require:
      - sls: {{ source }}.create
    - source: {{ template.template }}
    - name: tpl-{{ name }}

{% endmacro -%}
