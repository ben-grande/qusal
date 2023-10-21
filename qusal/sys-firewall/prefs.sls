{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .create

"{{ slsdotpath }}-qubes-prefs-updatevm":
  cmd.run:
    - require:
      - sls: {{ slsdotpath }}.create
    - name: qubes-prefs updatevm {{ slsdotpath }}

"{{ slsdotpath }}-qubes-prefs-default_netvm":
  cmd.run:
    - require:
      - sls: {{ slsdotpath }}.create
    - name: qubes-prefs default_netvm {{ slsdotpath }}
