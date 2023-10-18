"{{ slsdotpath }}-copy-tmux-home":
  file.recurse:
    - name: /home/user/
    - source: salt://{{ slsdotpath }}/files/tmux/
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: user
    - group: user

"{{ slsdotpath }}-fix-executables-tmux-home":
  file.directory:
    - name: /home/user/.local/bin
    - mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-copy-tmux-skel":
  file.recurse:
    - name: /etc/skel
    - source: salt://{{ slsdotpath }}/files/tmux/
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: root
    - group: root

"{{ slsdotpath }}-fix-executables-tmux-skel":
  file.directory:
    - name: /home/user/.local/bin
    - mode: '0755'
    - recurse:
      - mode
