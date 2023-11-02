{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{#
Qubes Sync Appmenus

Usage:
1: Import this template:
{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus -%}

2: Set qube to sync the appmenus:
{{ sync_appmenus('tpl-' ~ sls_path) }}
{{ sync_appmenus('tpl-ssh') }}
#}

{% macro sync_appmenus(qube) -%}

{% set running = 0 -%}
{% if salt['cmd.shell']('qvm-ls --no-spinner --raw-list --running ' ~ qube) == qube -%}
  {% set running = 1 -%}
{% endif -%}

"{{ qube }}-start":
  qvm.start:
    - name: {{ qube }}

{% set gui_user = salt['cmd.shell']('groupmems -l -g qubes') -%}
"{{ qube }}-sync-appmenus":
  cmd.run:
    - require:
      - qvm: {{ qube }}-start
    - name: qvm-sync-appmenus {{ qube }}
    - runas: {{ gui_user }}

{% if running == 0 -%}
"{{ qube }}-shutdown":
  qvm.shutdown:
    - require:
      - cmd: {{ qube }}-sync-appmenus
    - name: {{ qube }}
{% endif -%}

{% endmacro -%}
