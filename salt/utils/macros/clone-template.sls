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

## Avoid conflicting 'include' ID.
{% if source is iterable and (source is not string and source is not mapping) -%}

{%- import source[0] ~ "/template.jinja" as template -%}
{% set source_create = source | map('regex_replace', '$', '.create') | list %}
{% if include_create -%}
include: {{ source_create }}
{% endif %}
{% set source = source[0] -%}

{% else %}

{%- import source ~ "/template.jinja" as template -%}
{% if include_create -%}
include:
  - {{ source }}.create
{% endif %}

{% endif %}

"{{ prefix }}{{ name }}-clone":
  qvm.clone:
    - require:
      - sls: {{ source }}.create
    - source: {{ template.template }}
    - name: {{ prefix }}{{ name }}

{% endmacro -%}
