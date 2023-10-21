{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-change-prefs":
  cmd.script:
    - name: prefs.sh
    - source: salt://{{ slsdotpath }}/files/prefs.sh

{#
"{{ slsdotpath }}-start":
  qvm.start:
    - name: {{ slsdotpath }}

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
#}
