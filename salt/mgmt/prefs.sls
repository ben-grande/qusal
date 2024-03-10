{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-set-management_dispvm":
  cmd.run:
    - name: qubes-prefs management_dispvm dvm-{{ slsdotpath }}

"{{ slsdotpath }}-remove-default-mgmt-dvm":
  qvm.absent:
    - name: default-mgmt-dvm
    - require:
      - cmd: {{ slsdotpath }}-set-management_dispvm

## TODO: Remove when template with patch reaches upstream.
## https://github.com/QubesOS/qubes-issues/issues/8806
"{{ slsdotpath }}-shutdown-template":
  qvm.shutdown:
    - name: tpl-{{ slsdotpath }}
