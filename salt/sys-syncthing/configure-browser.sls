{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

include:
  - browser.configure

"{{ slsdotpath }}-browser-rc.local":
  file.managed:
    - name: /rw/config/rc.local.d/50-sys-syncthing.rc
    - source: salt://{{ slsdotpath }}/files/browser/rc.local.d/50-sys-syncthing.rc
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-browser-systemd-services":
  file.recurse:
    - name: /rw/config/systemd/
    - source: salt://{{ slsdotpath }}/files/browser/systemd/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-browser-desktop-application":
  file.managed:
    - name: /home/user/.local/share/applications/syncthing-browser.desktop
    - source: salt://{{ slsdotpath }}/files/browser/syncthing-browser.desktop
    - mode: '0644'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
