{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% set extraneous = salt['cmd.script']('salt://' ~ slsdotpath ~ '/files/admin/list-extra-tag.sh') -%}
"{{ slsdotpath }}-list-extra-tag":
  cmd.run:
    - name: echo {{ extraneous.stdout.split("\n") }}
