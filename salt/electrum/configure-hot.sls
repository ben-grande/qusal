{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-sh

"{{ slsdotpath }}-setconfig-check_updates":
  cmd.run:
    - name: electrum --offline setconfig check_updates false
    - runas: user

{% endif -%}
