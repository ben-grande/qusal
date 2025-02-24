{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{#
Usage:
1: Import this template:
{% from 'utils/macros/update-admin.sls' import update_admin -%}

2: Set template base to update and the reason for it:
{{ update_admin('fedora-minimal', 'tpl-sys-pgp') }}

The 'reason' is only used for creating a globally unique ID.
#}

{% macro update_admin(source, reason, shutdown=True, include_create=False) -%}
{% import source ~ "/template.jinja" as template -%}
{% import "dom0/gui-user.jinja" as gui_user -%}

{% if include_create -%}
include:
  - {{ source }}.create
{% endif -%}

"{{ reason }}-{{ source }}-update-admin":
  cmd.run:
    - require:
      - sls: {{ source }}.create
    - name: qubes-vm-update --no-progress --show-output --targets={{ template.template }}
    - runas: {{ gui_user.gui_user }}

{% if shutdown -%}
{#
Shutdown is necessary for cloned templates to have the newer state.
Even if 'qubes-vm-update' tries to shutdown a qube that was not previously
running, it does not wait for the shutdown to complete:
  https://github.com/qubesos/qubes-issues/issues/9814
#}
"{{ reason }}-{{ source }}-update-admin-shutdown":
  qvm.shutdown:
    - name: {{ template.template }}
    - flags:
      - wait
{% endif -%}

{% endmacro -%}
