"{{ slsdotpath }}-copy-sh-home":
  file.recurse:
    - name: /home/user/
    - source: salt://{{ slsdotpath }}/files/sh
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: user
    - group: user
    - keep_symlinks: True
    - force_symlinks: True

"{{ slsdotpath }}-fix-executables-sh-dir-home":
  file.directory:
    - name: /home/user/.local/bin
    - file_mode: '0755'
    - dir_mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-copy-sh-skel":
  file.recurse:
    - name: /etc/skel
    - source: salt://{{ slsdotpath }}/files/sh
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: root
    - group: root
    - keep_symlinks: True
    - force_symlinks: True

"{{ slsdotpath }}-fix-executables-sh-dir-skel":
  file.directory:
    - name: /etc/skel/.local/bin
    - file_mode: '0755'
    - dir_mode: '0755'
    - recurse:
      - mode
