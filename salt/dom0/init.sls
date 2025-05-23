{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

include:
  - {{ slsdotpath }}.backup
  - {{ slsdotpath }}.dotfiles
  - {{ slsdotpath }}.helpers
  - {{ slsdotpath }}.install
  - {{ slsdotpath }}.desktop-kde
  - {{ slsdotpath }}.update-settings
  - {{ slsdotpath }}.xorg
  - {{ slsdotpath }}.screenshot

{% endif -%}
