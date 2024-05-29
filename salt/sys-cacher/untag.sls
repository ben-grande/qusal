{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% set wanted = salt['cmd.shell']('qvm-ls --no-spinner --raw-list --tags updatevm-sys-cacher') -%}

{% if wanted -%}
{% for tpl in wanted.split("\n") %}
"{{ slsdotpath }}-del-tag-of-{{ tpl }}":
  qvm.tags:
    - name: {{ tpl }}
    - del:
      - updatevm-sys-cacher
{% endfor -%}
{% endif -%}
