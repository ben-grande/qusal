{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% set templates = salt['cmd.script']('salt://' ~ slsdotpath ~ '/files/admin/tag.py') -%}
{% for tpl in templates.stdout.split("\n") -%}
"{{ slsdotpath }}-add-tag-of-{{ tpl }}":
  qvm.tags:
    - name: {{ tpl }}
    - add:
      - updatevm-sys-cacher
{% endfor -%}
