{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - sys-ssh-agent.install-client

"{{ slsdotpath }}-updated-client":
  pkg.uptodate:
    - refresh: True

{% set pkg = {
    'Debian': {
      'pkg': ['sshfs'],
    },
    'RedHat': {
      'pkg': ['fuse-sshfs'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-client-os-specific":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-client-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/client/systemd/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-client-systemd-start-qubes-ssh-forwarder.socket":
  service.enabled:
    - name: qubes-ssh-forwarder.socket

{% endif -%}
