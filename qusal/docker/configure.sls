{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: |
        usermod -aG docker user
        systemctl unmask docker
        systemctl --no-block restart docker

{% endif -%}
