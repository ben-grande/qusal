{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

## TODO: Should we allow minions to decide which states they should run?
##       This is a hack substitute for top files, but it looks bad.
{#
include:
{% if grains['id'] == 'dom0' -%}
  - .create
{% elif grains['id'] == 'tpl-' ~ slsdotpath -%}
  - .install
{% elif grains['id'] == 'disp-' ~ slsdotpath -%}
  - utils.tools.zsh.touch-zshrc
{% elif grains['id'] == slsdotpath -%}
  - .configure
{% endif -%}
#}
