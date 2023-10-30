{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
{% if grains['id'] == 'dom0' -%}
  - .create
{% elif grains['id'] == 'tpl-' ~ slsdotpath -%}
  - .install
{% elif grains['id'] == 'dvm-' ~ slsdotpath -%}
  - .configure-qubes-executor
{% elif grains['id'] == slsdotpath -%}
  - .configure
{% endif -%}