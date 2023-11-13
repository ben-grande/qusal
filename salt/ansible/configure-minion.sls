{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-minion-start-sshd":
  file.managed:
    - name: /rw/config/rc.local
    - source: salt://{{ slsdotpath }}/files/client/rc.local
    - mode: '0755'
    - user: root
    - group: root

"{{ slsdotpath }}-minion-ssh-authorized_keys":
  file.touch:
    - name: /home/user/.ssh/authorized_keys
    - dir_mode: '0700'
    - file_mode: '0600'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
