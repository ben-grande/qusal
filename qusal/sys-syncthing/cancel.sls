"{{ slsdotpath }}-remove-service-from-rc.local":
  file.replace:
    - name: /rw/config/rc.local
    - pattern: 'systemctl.*unmask.*syncthing@user.service'
    - repl: ''
    - backup: False
