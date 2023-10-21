{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-set-management_dispvm":
  cmd.run:
    - name: qubes-prefs management_dispvm dvm-{{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.install

"{{ slsdotpath }}-remove-default-mgmt-dvm":
  qvm.absent:
    - name: default-mgmt-dvm
    - require:
      - cmd: {{ slsdotpath }}-set-management_dispvm
