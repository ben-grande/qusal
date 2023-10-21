{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-copy-x11-home":
  file.recurse:
    - name: /home/user/
    - source: salt://{{ slsdotpath }}/files/x11
    - file_mode: '0755'
    - dir_mode: '0755'
    - user: user
    - group: user
    - keep_symlinks: True
    - force_symlinks: True

"{{ slsdotpath }}-copy-x11-skel":
  file.recurse:
    - name: /etc/skel/
    - source: salt://{{ slsdotpath }}/files/x11
    - file_mode: '0755'
    - dir_mode: '0755'
    - user: root
    - group: root
    - keep_symlinks: True
    - force_symlinks: True
