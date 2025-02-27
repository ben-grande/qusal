{#
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- import "dom0/gui-user.jinja" as gui_user -%}

include:
  - utils.tools.helpers

"{{ slsdotpath }}-makedir-config-xfce":
  file.directory:
    - name: {{ gui_user.gui_user_home }}/.config/xfce4/
    - mode: '0755'
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}
    - makedirs: True

"{{ slsdotpath }}-copy-home":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-makedir-config-xfce"
    - name: {{ gui_user.gui_user_home }}/.config/xfce4/
    - source: salt://utils/tools/xfce/files/
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}
    - keep_symlinks: True
    - force_symlinks: True

"{{ slsdotpath }}-copy-skel":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-makedir-config-xfce"
    - name: /etc/skel/.config/xfce4/
    - source: salt://utils/tools/xfce/files/
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: root
    - group: root
    - keep_symlinks: True
    - force_symlinks: True
