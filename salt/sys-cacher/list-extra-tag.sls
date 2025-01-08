{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% set extraneous = salt['cmd.script']('salt://' ~ slsdotpath ~ '/files/admin/tag.py', args='--extraneous') -%}
"{{ slsdotpath }}-list-extra-tag":
  cmd.run:
    - name: printf '%s\n' {{ extraneous.stdout.split("\n") }}
