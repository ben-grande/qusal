{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

## TODO: Remove when template with patch reaches upstream or updates enforce
## salt-deps to be installed.
## https://github.com/QubesOS/qubes-issues/issues/8806

include:
  - .create

"{{ slsdotpath }}-set-management_dispvm-to-default":
  qvm.vm:
    - require:
      - cmd: "{{ slsdotpath }}-install-salt-deps"
    - name: tpl-{{ slsdotpath }}
    - prefs:
      - management_dispvm: "*default*"
