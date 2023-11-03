{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

"{{ slsdotpath }}-browser-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: "qvm-connect-tcp 8384:@default:8384"

"{{ slsdotpath }}-browser-desktop-application":
  file.managed:
    - name: /home/user/.local/share/applications/syncthing-browser.desktop
    - source: salt://{{ slsdotpath }}/files/browser/syncthing-browser.desktop
    - mode: '0644'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
