{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11

"{{ slsdotpath }}-create-autostart-dir":
  cmd.run:
    - name: mkdir -p ~/.config/autostart
    - runas: user

"{{ slsdotpath }}-desktop-autostart":
  cmd.run:
    - name: ln -sf /usr/share/applications/signal-desktop.desktop ~/.config/autostart/
    - runas: user

{% endif -%}
