{#
Usage:
1: Import this template:
{% from 'utils/macros/clone-template.sls' import clone_template -%}

2: Set template to clone from and the clone name:
{{ clone_template('debian-minimal', sls_path) }}
#}

{% macro clone_template(source, name) -%}

{%- import "templates/" ~ source ~ ".jinja" as template -%}

include:
  - templates.{{ source }}.create

"tpl-{{ name }}-clone":
  qvm.clone:
    - require:
      - sls: templates.{{ source }}.clone
    - source: {{ template.template }}
    - name: tpl-{{ name }}

{% endmacro -%}
