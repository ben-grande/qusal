{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-client-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: |
        systemctl enable qubes-ssh-forwarder.socket
        systemctl start qubes-ssh-forwarder.socket
        sshfs -p 840 localhost:/home/tx tx

"{{ slsdotpath }}-home-tx-dir-client":
  file.directory:
    - name: /home/user/tx
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-home-ssh-dir-client":
  file.directory:
    - name: /home/user/.ssh
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-ssh-forwarder-template-to-systemd-bind":
  file.managed:
    - name: /rw/bind-dirs/lib/systemd/system/qubes-ssh-forwarder@.service
    - source: salt://{{ slsdotpath }}/files/client/qubes-ssh-forwarder@.service
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-ssh-forwarder-socket-to-systemd-bind":
  file.managed:
    - name: /rw/bind-dirs/lib/systemd/system/qubes-ssh-forwarder.socket
    - source: salt://{{ slsdotpath }}/files/client/qubes-ssh-forwarder.socket
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-bind-sshfs-client"
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/50_sshfs.conf
    - source: salt://{{ slsdotpath }}/files/client/50_sshfs.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True
