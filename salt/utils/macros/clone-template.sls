{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{#
Usage:
1: Import this template:
{% from 'utils/macros/clone-template.sls' import clone_template -%}

2: Set template to clone from and the clone name:
{{ clone_template('debian-minimal', sls_path) }}
#}

{% macro clone_template(source, name, prefix='tpl-', include_create=True) -%}

{%- import source ~ "/template.jinja" as template -%}

{% if include_create -%}
include:
  - {{ source }}.create
{% endif -%}

"{{ prefix }}{{ name }}-clone":
  qvm.clone:
    - require:
      - sls: {{ source }}.create
    - source: {{ template.template }}
    - name: {{ prefix }}{{ name }}

{% endmacro -%}
