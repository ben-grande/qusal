{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup

"{{ slsdotpath }}-start-ssh-on-boot":
  file.append:
    - name: /rw/config/rc.local
    - source: salt://{{ slsdotpath }}/files/server/rc.local

"{{ slsdotpath }}-creates-home-ssh-dir":
  file.directory:
    - name: /home/user/.ssh
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
