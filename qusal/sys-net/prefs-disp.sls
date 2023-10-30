{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .create

{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
"default_netvm-netvm-disp-{{ slsdotpath }}":
  qvm.vm:
    - require:
      - qvm: disp-{{ slsdotpath }}
    - name: {{ default_netvm }}
    - prefs:
      - netvm: disp-{{ slsdotpath }}

"clockvm-disp-{{ slsdotpath }}":
  cmd.run:
    - require:
      - qvm: disp-{{ slsdotpath }}
    - name: qubes-prefs clockvm disp-{{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
