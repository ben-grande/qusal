{% from 'utils/macros/sync-appmenus.sls' import sync_appmenus -%}
{{ sync_appmenus('tpl-' ~ sls_path) }}
