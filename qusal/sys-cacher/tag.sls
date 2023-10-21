{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% set avoid = salt['cmd.shell']('qvm-ls --no-spinner --raw-list --tags whonix-updatevm') -%}

{% set exclude = salt['cmd.shell']('for qube in ' ~ avoid ~ '; do exclude="$exclude --exclude $qube"; done; echo "$exclude"') -%}

{% set wanted = salt['cmd.shell']('qvm-ls --no-spinner --raw-data --fields=NAME,CLASS --all ' ~ exclude ~ ' | awk -F "|" "/|TemplateVM|/{print $1}"') -%}

{% for tpl in wanted -%}
"{{ tpl }}-cacher-tag":
  qvm.tags:
    - name: {{ tpl }}
    - add:
      - sys-cacher-updatevm
{% endfor -%}
