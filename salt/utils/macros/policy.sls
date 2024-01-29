{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{#
Qubes RPC Policy Template

Usage:

UNSET POLICY:
------------
{% from 'utils/macros/policy.sls' import policy_unset with context -%}
{{ policy_unset(sls_path, '80') }}

SET POLICY:
-----------
{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}

{% from 'utils/macros/policy.sls' import policy_set_full with context -%}
{{ policy_set_full('project', '/etc/qubes/policy.d/80-project.policy', 'salt://project/files/admin/policy/default.policy') }}

If you prefer to use 'contents' instead of 'source':
{% from 'utils/macros/policy.sls' import load_policy -%}
{% load_yaml as defaults_policy -%}
name: /etc/qubes/policy.d/80-{{ slsdotpath }}.policy
contents:
  - "## Comments need to be quoted."
  - qubes.Example * {{ slsdotpath }} @default ask target=sys-test
  - qubes.Example * {{ slsdotpath }} sys-test ask
{%- endload %}
{{ load_policy(defaults_policy) }}

#}

{% set policy_mode = '0664' -%}
{% set policy_user = 'root' -%}
{% set policy_group = 'qubes' -%}

{% macro policy_unset(project, number) -%}
"{{ project }}-absent-rpc-policy":
  file.absent:
    - name: /etc/qubes/policy.d/{{ number ~ '-' ~ project }}.policy
{%- endmacro %}

{% macro policy_set(project, number) -%}
"{{ project }}-set-rpc-policy":
  file.managed:
    - name: /etc/qubes/policy.d/{{ number ~ '-' ~ project }}.policy
    - source: salt://{{ project }}/files/admin/policy/default.policy
    - template: jinja
    - context:
        sls_path: {{ project }}
    - mode: {{ policy_mode }}
    - user: {{ policy_user }}
    - group: {{ policy_group }}
{% endmacro -%}

{% macro policy_set_full(project, name, source) -%}
"{{ project }}-set-full-rpc-policy":
  file.managed:
    - name: {{ name }}
    - source: {{ source }}
    - template: jinja
    - context:
        sls_path: {{ project }}
    - mode: {{ policy_mode }}
    - user: {{ policy_user }}
    - group: {{ policy_group }}
{% endmacro -%}

{% macro state_policy(name, contents) -%}
"{{ name }}-rpc-policy":
  file.managed:
    - name: {{ name }}
    - contents: {{ contents }}
    - mode: {{ policy_mode }}
    - user: {{ policy_user }}
    - group: {{ policy_group }}
{%- endmacro %}

{% macro load_policy(policy) -%}
  {{- state_policy(policy.name, policy.contents) }}
{%- endmacro %}
