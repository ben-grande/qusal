{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11
  - dotfiles.copy-xfce

"{{ slsdotpath }}-desktop-autostart":
  file.symlink:
    - name: /home/user/.config/autostart/signal-desktop.desktop
    - target: /usr/share/applications/signal-desktop.desktop
    - user: user
    - group: user
    - force: True
    - makedirs: True

{% endif -%}
