{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-copy-net-home":
  file.recurse:
    - name: /home/user/
    - source: salt://{{ slsdotpath }}/files/net/
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: user
    - group: user
    - keep_symlinks: True
    - force_symlinks: True

"{{ slsdotpath }}-copy-net-skel":
  file.recurse:
    - name: /etc/skel
    - source: salt://{{ slsdotpath }}/files/net/
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: root
    - group: root
    - keep_symlinks: True
    - force_symlinks: True
