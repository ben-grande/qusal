{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-common
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-sh

"{{ slsdotpath }}-client-bin":
  file.recurse:
    - name: /usr/bin/
    - source: salt://{{ slsdotpath }}/files/client/bin/
    - file_mode: '0755'
    - dir_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-client-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/client/systemd/
    - file_mode: '0644'
    - dir_mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-client-system-service-enable-bitcoin-rpc-qrexec":
  service.enabled:
    - name: bitcoin-rpc-qrexec.socket

{% endif -%}
