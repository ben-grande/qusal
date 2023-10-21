{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .create

{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
"disp-{{ slsdotpath }}-set-{{ default_netvm }}-netvm":
  qvm.vm:
    - require:
      - qvm: disp-{{ slsdotpath }}
    - name: {{ default_netvm }}
    - prefs:
      - netvm: disp-{{ slsdotpath }}

"disp-{{ slsdotpath }}-clockvm":
  cmd.run:
    - require:
      - qvm: disp-{{ slsdotpath }}
    - name: qubes-prefs clockvm disp-{{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
