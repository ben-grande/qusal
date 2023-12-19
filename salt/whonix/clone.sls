{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- import slsdotpath ~ "/template.jinja" as whonix -%}

"{{ whonix.whonix_gateway_template }}-installed":
  qvm.template_installed:
    - name: {{ whonix.whonix_gateway_template }}
    - fromrepo: {{ whonix.whonix_repo }}

"{{ whonix.whonix_workstation_template }}-installed":
  qvm.template_installed:
    - name: whonix-workstation-{{ whonix.whonix_workstation_template }}
    - fromrepo: {{ whonix.whonix_repo }}
