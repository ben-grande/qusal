{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-net
  - dotfiles.copy-sh
  - dotfiles.copy-x11

"{{ slsdotpath }}-executor-makedir-binded-builder":
  file.directory:
    - name: /rw/bind-dirs/builder
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-executor-bind-dirs":
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/50-qubes-builder.conf
    - source: salt://{{ slsdotpath }}/files/server/qubes-bind-dirs.d/50-qubes-builder.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

"{{ slsdotpath }}-executor-rc.local":
  file.managed:
    - name: /rw/config/rc.local.d/50-qubes-builder.rc
    - source: salt://{{ slsdotpath }}/files/server/rc.local.d/50-qubes-builder.rc
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

{% endif -%}
