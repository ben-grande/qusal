{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-copy-git-home":
  file.recurse:
    - name: /home/user
    - source: salt://{{ slsdotpath }}/files/git
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: user
    - group: user

"{{ slsdotpath }}-fix-executables-git-template-dir-home":
  file.directory:
    - name: /home/user/.config/git/template/hooks
    - mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-fix-executables-git-shell-dir-home":
  file.directory:
    - name: /home/user/.config/git/shell
    - mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-fix-executables-git-bin-dir-home":
  file.directory:
    - name: /home/user/.local/bin
    - mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-copy-git-skel":
  file.recurse:
    - name: /etc/skel
    - source: salt://{{ slsdotpath }}/files/git
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: root
    - group: root

"{{ slsdotpath }}-fix-executables-git-template-dir-skel":
  file.directory:
    - name: /etc/skel/.config/git/template/hooks
    - mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-fix-executables-git-shell-dir-skel":
  file.directory:
    - name: /home/user/.config/git/shell
    - mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-fix-executables-git-bin-dir-skel":
  file.directory:
    - name: /home/user/.local/bin
    - mode: '0755'
    - recurse:
      - mode
