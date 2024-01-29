{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% set qube = 'sys-pihole' -%}
{% set running = 0 -%}
{% if salt['cmd.shell']('qvm-ls --no-spinner --raw-list --running ' ~ qube) == qube -%}
  {% set running = 1 -%}
{% endif -%}

"{{ slsdotpath }}-start":
  qvm.start:
    - name: {{ slsdotpath }}

"{{ slsdotpath }}-change-prefs":
  cmd.script:
    - name: prefs.sh
    - source: salt://{{ slsdotpath }}/files/admin/prefs.sh

"{{ slsdotpath }}-qubes-prefs-clockvm":
  cmd.run:
    - require:
      - qvm: "{{ slsdotpath }}-start"
    - name: qubes-prefs clockvm {{ slsdotpath }}

"{{ slsdotpath }}-qubes-prefs-updatevm":
  cmd.run:
    - require:
      - qvm: "{{ slsdotpath }}-start"
    - name: qubes-prefs updatevm {{ slsdotpath }}

"{{ slsdotpath }}-qubes-prefs-default_netvm":
  cmd.run:
    - require:
      - qvm: "{{ slsdotpath }}-start"
    - name: qubes-prefs default_netvm {{ slsdotpath }}

{% if running == 0 -%}
"{{ slsdotpath }}-shutdown":
  qvm.shutdown:
    - name: {{ default_netvm }}
    - flags:
      - wait
      - force
{% endif -%}
