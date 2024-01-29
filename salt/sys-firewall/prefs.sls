{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% set qube = slsdotpath -%}

{% set running = 0 -%}
{% if salt['cmd.shell']('qvm-ls --no-spinner --raw-list --running ' ~ qube) == qube -%}
  {% set running = 1 -%}
{% endif -%}

"{{ qube }}-start":
  qvm.start:
    - name: {{ qube }}

"{{ qube }}-qubes-prefs-updatevm":
  cmd.run:
    - require:
      - qvm: {{ qube }}-start
    - name: qubes-prefs updatevm {{ qube }}

"{{ qube }}-qubes-prefs-default_netvm":
  cmd.run:
    - require:
      - qvm: {{ qube }}-start
    - name: qubes-prefs default_netvm {{ qube }}

"{{ qube }}-qubes-prefs-clockvm":
  cmd.run:
    - require:
      - qvm: {{ qube }}-start
    - name: qubes-prefs clockvm {{ qube }}

{% if running == 0 -%}
"{{ qube }}-shutdown":
  qvm.shutdown:
    - name: {{ qube }}
    - flags:
      - wait
      - force
{% endif -%}
