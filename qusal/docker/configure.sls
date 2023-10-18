{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: |
        usermod -aG docker user
        systemctl start docker

{% endif -%}
