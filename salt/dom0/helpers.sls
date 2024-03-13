{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

"{{ slsdotpath }}-terminal-helper":
  file.managed:
    - name: /usr/local/bin/qvm-terminal
    - source: salt://{{ slsdotpath }}/files/bin/qvm-terminal
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-file-manager-helper":
  file.symlink:
    - require:
      - file: "{{ slsdotpath }}-terminal-helper"
    - name: /usr/local/bin/qvm-file-manager
    - target: /usr/local/bin/qvm-terminal
    - user: root
    - group: root
    - force: True
    - makedirs: True

"{{ slsdotpath }}-copy-to-dom0-helper":
  file.managed:
    - name: /usr/local/bin/qvm-copy-to-dom0
    - source: salt://{{ slsdotpath }}/files/bin/qvm-copy-to-dom0
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-screenshot-helper":
  file.managed:
    - name: /usr/local/bin/qvm-screenshot
    - source: salt://{{ slsdotpath }}/files/bin/qvm-screenshot
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

## TODO: KDE shortcuts
{% set gui_user = salt['cmd.shell']('groupmems -l -g qubes') -%}
{% set gui_user_id = salt['cmd.shell']('id -u ' ~ gui_user) -%}
"{{ slsdotpath }}-screenshot-keyboard-shortcuts-xfce":
  cmd.run:
    - name: |
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/{{ gui_user_id }}/bus"
        export DBUS_SESSION_BUS_ADDRESS
        xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/Print" -n -s "qvm-screenshot --fullscreen"
        xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Alt>Print" -n -s "qvm-screenshot --region"
    - runas: {{ gui_user }}
    - require:
      - file: "{{ slsdotpath }}-screenshot-helper"

{% endif -%}
