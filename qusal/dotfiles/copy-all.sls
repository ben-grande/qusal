include:
  - .copy-git
  - .copy-gtk
  - .copy-net
  - .copy-pgp
  - .copy-sh
  - .copy-ssh
  - .copy-tmux
  - .copy-vim
  - .copy-x11

{#
Unfortunately salt.states.file does not keep permissions when using salt-ssh.
Best option is 'file.managed mode: keep' or 'file.recurse file_mode: keep'.
https://docs.saltproject.io/en/latest/ref/states/all/salt.states.file.html
#}
{#
"{{ slsdotpath }}-absent-dotfiles-client":
  file.absent:
    - name: /tmp/dotfiles

"{{ slsdotpath }}-copy-dotfiles-client":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files
    - name: /tmp/dotfiles
    - file_mode: '0644'
    - dir_mode: '0700'
    - user: user
    - group: user

"{{ slsdotpath }}-apply-dotfiles-client":
  cmd.run:
    - name: sh /tmp/dotfiles/setup.sh
    - runas: user

"{{ slsdotpath }}-fix-executables-permission":
  file.directory:
    - name: /home/user/.local/bin
    - mode: '0755'
    - recurse:
      - mode

"{{ slsdotpath }}-absent-end-dotfiles-client":
  file.absent:
    - name: /tmp/dotfiles
#}
