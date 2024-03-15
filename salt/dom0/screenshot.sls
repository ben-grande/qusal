{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

"{{ slsdotpath }}-screenshot-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-screenshot-installed":
  pkg.installed:
    - require:
      - pkg: "{{ slsdotpath }}-screenshot-updated"
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - zenity
      - scrot

"{{ slsdotpath }}-screenshot-script":
  file.managed:
    - name: /usr/local/bin/qvm-screenshot
    - source: salt://{{ slsdotpath }}/files/bin/qvm-screenshot
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True
    - require:
      - pkg: "{{ slsdotpath }}-screenshot-installed"

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
      - file: "{{ slsdotpath }}-screenshot-script"

{% endif -%}
