{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

include:
  - .install
  - .backup
  - .xorg
  - .kde
  - .dotfiles

{% endif -%}
