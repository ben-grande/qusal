{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - .create

"{{ slsdotpath }}-update-admin":
  cmd.run:
    - require:
      - sls: {{ slsdotpath }}.create
    - name: qubes-vm-update --no-progress --show-output --targets={{ template.template }}

{% endif %}
