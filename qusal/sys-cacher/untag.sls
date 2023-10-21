{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% set wanted = salt['cmd.shell']('qvm-ls --no-spinner --raw-list') -%}

{% for tpl in wanted.replace(",", " ") -%}
"{{ tpl }}-cacher-untag":
  qvm.tags:
    - name: {{ tpl }}
    - del:
      - sys-cacher-updatevm
{% endfor -%}
