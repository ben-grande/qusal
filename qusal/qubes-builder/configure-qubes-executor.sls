{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-net
  - dotfiles.copy-sh
  - dotfiles.copy-x11

"{{ slsdotpath }}-executor-rpc":
  file.managed:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True
    - names:
      - /usr/local/etc/qubes-rpc/qubesbuilder.FileCopyIn:
        - source: salt://{{ slsdotpath }}/files/rpc/qubesbuilder.FileCopyIn
      - /usr/local/etc/qubes-rpc/qubesbuilder.FileCopyOut:
        - source: salt://{{ slsdotpath }}/files/rpc/qubesbuilder.FileCopyOut

"{{ slsdotpath }}-executor-makedir-binded-builder":
  file.directory:
    - name: /rw/bind-dirs/builder
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-executor-bind-dirs":
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/builder.conf
    - source: salt://{{ slsdotpath }}/files/qubes-executor/builder.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

"{{ slsdotpath }}-executor-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: "mount /builder -o dev,suid,remount"

{% endif -%}
