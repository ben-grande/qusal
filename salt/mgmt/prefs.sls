{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - .create

"{{ slsdotpath }}-set-qubes-prefs-management_dispvm-to-dvm-{{ slsdotpath }}":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-install-salt-deps"
    - name: qubes-prefs management_dispvm dvm-{{ slsdotpath }}

"{{ slsdotpath }}-set-tpl-{{ slsdotpath }}-management_dispvm-to-default":
  qvm.vm:
    - require:
      - cmd: "{{ slsdotpath }}-install-salt-deps"
    - name: tpl-{{ slsdotpath }}
    - prefs:
      - management_dispvm: "*default*"

"{{ slsdotpath }}-remove-default-mgmt-dvm":
  qvm.absent:
    - require:
      - cmd: "{{ slsdotpath }}-set-qubes-prefs-management_dispvm-to-dvm-{{ slsdotpath }}"
      - qvm: "{{ slsdotpath }}-set-tpl-{{ slsdotpath }}-management_dispvm-to-default"
    - name: default-mgmt-dvm

## TODO: Remove when template with patch reaches upstream or updates enforce
## salt-deps to be installed.
## https://github.com/QubesOS/qubes-issues/issues/8806
"{{ slsdotpath }}-shutdown-template":
  qvm.shutdown:
    - require:
      - qvm: "{{ slsdotpath }}-set-tpl-{{ slsdotpath }}-management_dispvm-to-default"
    - name: tpl-{{ slsdotpath }}
    - flags:
      - force
