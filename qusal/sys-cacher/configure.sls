{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11

"{{ slsdotpath }}-install-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: |
        chown -R apt-cacher-ng:apt-cacher-ng /var/log/apt-cacher-ng
        chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng
        systemctl unmask apt-cacher-ng
        systemctl start apt-cacher-ng
        nft 'insert rule ip filter INPUT tcp dport 8082 counter accept'

"{{ slsdotpath }}-install-qubes-firewall-user-script":
  file.append:
    - name: /rw/config/qubes-firewall-user-script
    - text: nft 'insert rule ip filter INPUT tcp dport 8082 counter accept'

"{{ slsdotpath }}-bind-dirs":
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/50_user.conf
    - source: salt://{{ slsdotpath }}/files/bind-dirs/50_user.conf
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
