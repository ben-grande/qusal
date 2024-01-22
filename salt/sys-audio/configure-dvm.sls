{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup

"{{ slsdotpath }}-desktop-volumeicon":
  file.managed:
    - name: /home/user/.local/share/applications/volumeicon.desktop
    - source: salt://{{ slsdotpath }}/files/dvm/volumeicon.desktop
    - mode: '0644'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-autostart-volumeicon":
  file.symlink:
    - name: /home/user/.config/autostart/volumeicon.desktop
    - target: /home/user/.local/share/applications/volumeicon.desktop
    - user: user
    - group: user
    - force: True
    - makedirs: True

"{{ slsdotpath }}-desktop-qvm-start-daemon":
  file.managed:
    - name: /home/user/.local/share/applications/qvm-start-daemon.desktop
    - source: salt://{{ slsdotpath }}/files/dvm/qvm-start-daemon.desktop
    - mode: '0644'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-autostart-qvm-start-daemon":
  file.symlink:
    - name: /home/user/.config/autostart/qvm-start-daemon.desktop
    - target: /home/user/.local/share/applications/qvm-start-daemon.desktop
    - user: user
    - group: user
    - force: True
    - makedirs: True

{% endif -%}
