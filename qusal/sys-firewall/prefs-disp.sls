{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .create

"{{ slsdotpath }}-qubes-prefs-updatevm":
  cmd.run:
    - require:
      - sls: {{ slsdotpath }}.clone
    - name: qubes-prefs updatevm disp-{{ slsdotpath }}

"{{ slsdotpath }}-qubes-prefs-default_netvm":
  cmd.run:
    - require:
      - sls: {{ slsdotpath }}.clone
    - name: qubes-prefs default_netvm disp-{{ slsdotpath }}
