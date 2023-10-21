{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-copy-pgp-home":
  file.recurse:
    - name: /home/user/
    - source: salt://{{ slsdotpath }}/files/pgp/
    - file_mode: '0600'
    - dir_mode: '0700'
    - user: user
    - group: user

"{{ slsdotpath }}-copy-pgp-skel":
  file.recurse:
    - name: /etc/skel/
    - source: salt://{{ slsdotpath }}/files/pgp/
    - file_mode: '0600'
    - dir_mode: '0700'
    - user: root
    - group: root
