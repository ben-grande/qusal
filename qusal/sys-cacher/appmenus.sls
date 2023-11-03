{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - browser.appmenus

{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus -%}
{{ sync_appmenus('tpl-' ~ sls_path) }}

{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus -%}
{{ sync_appmenus(sls_path ~ '-browser') }}
