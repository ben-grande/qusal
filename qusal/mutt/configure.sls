{% if grains['nodename'] != 'dom0' %}

include:
  - dotfiles.copy-x11
  - dotfiles.copy-sh

"{{ slsdotpath }}-home-muttrc":
  file.recurse:
    - name: /home/user/.config/mutt
    - source: salt://{{ slsdotpath }}/files/mutt
    - file_mode: '0644'
    - dir_mode: '0755'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
