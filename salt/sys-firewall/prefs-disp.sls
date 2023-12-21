{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - .create

"disp-{{ slsdotpath }}-qubes-prefs-updatevm":
  cmd.run:
    - require:
      - sls: {{ slsdotpath }}.clone
    - name: qubes-prefs updatevm disp-{{ slsdotpath }}

"disp-{{ slsdotpath }}-qubes-prefs-default_netvm":
  cmd.run:
    - require:
      - sls: {{ slsdotpath }}.clone
    - name: qubes-prefs default_netvm disp-{{ slsdotpath }}

"disp-{{ slsdotpath }}-qubes-prefs-clockvm":
  cmd.run:
    - require:
      - sls: {{ slsdotpath }}.create
    - name: qubes-prefs clockvm disp-{{ slsdotpath }}
