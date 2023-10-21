{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{%- import slsdotpath ~ "/template.jinja" as whonix -%}

"{{ whonix.whonix_gw_template }}-installed":
  qvm.template_installed:
    - name: {{ whonix.whonix_gw_template }}
    - fromrepo: {{ whonix.whonix_repo }}

"{{ whonix.whonix_ws_template }}-installed":
  qvm.template_installed:
    - name: whonix-ws-{{ whonix.whonix_ws_template }}
    - fromrepo: {{ whonix.whonix_repo }}
