{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

"{{ slsdotpath }}-start-ssh-on-boot":
  file.append:
    - name: /rw/config/rc.local
    - text: |
        systemctl unmask ssh
        systemctl start ssh

"{{ slsdotpath }}-create-home-ssh-dir":
  file.directory:
    - name: /home/user/.ssh
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-creates-tx-dir":
  file.directory:
    - name: /home/tx
    - mode: '0777'
    - user: user
    - group: user
    - makedirs: True
