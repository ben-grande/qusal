{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.zsh.touch-zshrc

"{{ slsdotpath }}-autostart-ssh-over-qrexec":
  file.managed:
    - name: /rw/config/rc.local.d/50-ansible.rc
    - source: salt://{{ slsdotpath }}/files/server/rc.local.d/50-ansible.rc
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

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
