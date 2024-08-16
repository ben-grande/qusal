{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - sys-ssh-agent.install-client

{% set pkg = {
    'Debian': {
      'pkg': ['sshfs'],
    },
    'RedHat': {
      'pkg': ['fuse-sshfs'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-client-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-ssh-config":
  file.managed:
    - name: /etc/ssh/ssh_config.d/50-qusal-{{ slsdotpath }}.conf
    - source: salt://{{ slsdotpath }}/files/client/ssh_config.d/50-qusal-{{ slsdotpath }}.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-client-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/client/systemd/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-client-systemd-start-qusal-ssh-forwarder.socket":
  service.enabled:
    - name: qusal-ssh-forwarder.socket

{% endif -%}
