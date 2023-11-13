{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{#
Switch Template to Default Template

Usage:
1: Import this template:
{% from 'utils/macros/switch-template.sls' import switch_template -%}

2: Set list of qubes to set default template:
{{ switch_template([sls_path, 'example']) }}
#}

{% set default_template = salt['cmd.shell']('qubes-prefs default_template') -%}

{% macro switch_template(qubes) -%}
{% for qube in qubes -%}
"{{ slsdotpath }}-reset-{{ qube }}-template-to-default_template":
  cmd.run:
    - name: qvm-prefs {{ qube }} template {{ default_template }}
{% endfor -%}
{% endmacro -%}
