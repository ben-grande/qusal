{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- import slsdotpath ~ "/template.jinja" as template -%}

"{{ template.template }}-template-installed":
  qvm.template_installed:
    - name: {{ template.template }}
    - fromrepo: {{ template.repo }}
