{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
{% if grains['id'] == 'dom0' -%}
  - {{ slsdotpath }}.create
{% elif grains['id'] == 'tpl-' ~ slsdotpath -%}
  - {{ slsdotpath }}.install
{% elif grains['id'] == 'dvm-' ~ slsdotpath -%}
  - {{ slsdotpath }}.configure-qubes-executor
{% elif grains['id'] == slsdotpath -%}
  - {{ slsdotpath }}.configure
{% endif -%}
