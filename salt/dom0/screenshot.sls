{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

{%- import slsdotpath ~ "/gui-user.jinja" as gui_user -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-screenshot-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - zenity
      - maim

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
"{{ slsdotpath }}-screenshot-keyboard-shortcuts-xfce":
  cmd.run:
    - name: |
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/{{ gui_user.gui_user_id }}/bus"
        export DBUS_SESSION_BUS_ADDRESS
        xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/Print" -n -s "qvm-screenshot --fullscreen"
        xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Alt>Print" -n -s "qvm-screenshot --region"
    - runas: {{ gui_user.gui_user }}
    - require:
      - file: "{{ slsdotpath }}-screenshot-script"

{% endif -%}
