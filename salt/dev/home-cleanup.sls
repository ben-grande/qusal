{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}
{% for unused_dir in ['Desktop','Documents','Downloads','Music','Pictures','Public','Templates','Videos'] -%}

  {% set full_unused_dir = '/home/user/' ~ unused_dir -%}
  "remove-{{ full_unused_dir }}":
    file.absent:
      - name: {{ full_unused_dir }}
      - onlyif: test -z "$(ls -A -- {{ full_unused_dir }})"

{% endfor -%}
{% endif -%}
