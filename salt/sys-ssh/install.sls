{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - openssh-server
      - man-db

"{{ slsdotpath }}-stop-ssh":
  service.dead:
    - name: ssh

"{{ slsdotpath }}-disable-ssh":
  service.disabled:
    - name: ssh

"{{ slsdotpath }}-mask-ssh":
  service.masked:
    - name: ssh

"{{ slsdotpath }}-rpc":
  file.symlink:
    - name: /etc/qubes-rpc/qusal.Ssh
    - target: /dev/tcp/127.0.0.1/22
    - user: root
    - group: root
    - force: True
    - makedirs: True

"{{ slsdotpath }}-rpc-config":
  file.symlink:
    - name: /etc/qubes/rpc-config/qusal.Ssh
    - target: /etc/qubes/rpc-config/qubes.ConnectTCP
    - user: root
    - group: root
    - force: True
    - makedirs: True

"{{ slsdotpath }}-sshd-config":
  file.managed:
    - name: /etc/ssh/sshd_config.d/{{ slsdotpath }}.conf
    - source: salt://{{ slsdotpath }}/files/server/sshd_config.d/{{ slsdotpath }}.conf
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
