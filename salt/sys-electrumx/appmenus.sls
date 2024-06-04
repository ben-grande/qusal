{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus -%}
{{ sync_appmenus('tpl-sys-electrumx') }}

{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus -%}
{{ sync_appmenus('tpl-electrumx-builder') }}
