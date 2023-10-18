"{{ slsdotpath }}-append-to-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: |
        systemctl unmask syncthing@user.service
        systemctl start  syncthing@user.service
