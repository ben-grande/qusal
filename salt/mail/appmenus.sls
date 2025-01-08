{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - reader.appmenus

{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus -%}
{{ sync_appmenus('tpl-' ~ sls_path ~ '-sender') }}
{{ sync_appmenus('tpl-' ~ sls_path ~ '-reader') }}
{{ sync_appmenus('tpl-' ~ sls_path ~ '-fetcher') }}
