{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-autostart-ssh-over-qrexec":
  file.managed:
    - name: /rw/config/rc.local
    - source: salt://{{ slsdotpath }}/files/server/rc.local
    - mode: '0755'
    - user: root
    - group: root

"{{ slsdotpath }}-ssh-config":
  file.managed:
    - name: /home/user/.ssh/config
    - source: salt://{{ slsdotpath }}/files/server/ssh-config
    - file_mode: '0600'
    - dir_mode: '0700'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
