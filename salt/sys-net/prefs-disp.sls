{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% set netvm = 'disp-' ~ slsdotpath -%}
{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}

{% set running = 0 -%}
{% if salt['cmd.shell']('qvm-ls --no-spinner --raw-list --running ' ~ default_netvm) == default_netvm -%}
  {% set running = 1 -%}
{% endif -%}

"{{ slsdotpath }}-{{ default_netvm }}-shutdown":
  qvm.shutdown:
    - name: {{ default_netvm }}
    - flags:
      - wait
      - force

{% set default_netvm_netvm = salt['cmd.shell']('qvm-prefs ' ~ default_netvm ~ ' netvm') -%}
{% if default_netvm_netvm -%}
"{{ slsdotpath }}-{{ default_netvm_netvm }}-shutdown":
  qvm.shutdown:
    - require:
      - qvm: "{{ slsdotpath }}-{{ default_netvm }}-shutdown"
    - name: {{ default_netvm_netvm }}
    - flags:
      - wait
      - force
{% endif -%}

{% from 'utils/macros/policy.sls' import policy_set_full with context -%}
{{ policy_set_full(slsdotpath, '/etc/qubes/policy.d/80-' ~ slsdotpath ~ '.policy', 'salt://' ~ slsdotpath ~ '/files/admin/policy/default-disp.policy') }}

"{{ slsdotpath }}-set-{{ default_netvm }}-netvm-to-{{ netvm }}":
  qvm.vm:
    - require:
      - qvm: "{{ slsdotpath }}-{{ default_netvm }}-shutdown"
    - name: {{ default_netvm }}
    - prefs:
      - netvm: {{ netvm }}

{% if running == 1 -%}
"{{ slsdotpath }}-{{ default_netvm }}-start":
  qvm.start:
    - name: {{ default_netvm }}
{% endif -%}
