{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

## TODO: Should we allow minions to decide which states they should run?
## This is a hack substitute for top files without the need to specify each
## state file, but it looks bad.
## Example: qubesctl --targets=dom0,tpl-dev,disp-dev,dev state.apply dev
{#
include:
{% if grains['id'] == 'dom0' -%}
  - {{ slsdotpath }}.create
{% elif grains['id'] == 'tpl-' ~ slsdotpath -%}
  - {{ slsdotpath }}.install
{% elif grains['id'] == 'disp-' ~ slsdotpath -%}
  - utils.tools.zsh.touch-zshrc
{% elif grains['id'] == slsdotpath -%}
  - {{ slsdotpath }}.configure
{% endif -%}
#}
