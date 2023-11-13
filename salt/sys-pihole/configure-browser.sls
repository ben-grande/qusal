{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

"{{ slsdotpath }}-browser-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: "qvm-connect-tcp 80:@default:80"

"{{ slsdotpath }}-browser-desktop-application":
  file.managed:
    - name: /home/user/.local/share/applications/pihole-browser.desktop
    - source: salt://{{ slsdotpath }}/files/browser/pihole-browser.desktop
    - mode: '0644'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
