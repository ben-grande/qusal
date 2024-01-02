{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-autostart-volumeicon-systray":
  file.managed:
    - name: /home/user/.local/share/applications/volumeicon.desktop
    - source: salt://{{ slsdotpath }}/files/dvm/volumeicon.desktop
    - mode: '0644'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-desktop-autostart":
  file.symlink:
    - name: /home/user/.config/autostart/volumeicon.desktop
    - target: /home/user/.local/share/applications/volumeicon.desktop
    - user: user
    - group: user
    - force: True
    - makedirs: True

{% endif -%}
