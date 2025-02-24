{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - .create

"{{ slsdotpath }}-set-{{ template.template }}-management_dispvm-to-default":
  qvm.vm:
    - require:
      - sls: {{ slsdotpath }}.create
    - name: {{ template.template }}
    - prefs:
      - management_dispvm: "*default*"
