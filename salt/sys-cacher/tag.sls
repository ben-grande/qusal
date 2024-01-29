{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% set templates = salt['cmd.script']('salt://' ~ slsdotpath ~ '/files/admin/tag.sh') -%}
{% for tpl in templates.stdout.split("\n") -%}
"{{ slsdotpath }}-tag-for-{{ tpl }}":
  qvm.tags:
    - name: {{ tpl }}
    - add:
      - updatevm-sys-cacher
{% endfor -%}
