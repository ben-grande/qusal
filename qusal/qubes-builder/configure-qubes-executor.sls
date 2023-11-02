{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-net
  - dotfiles.copy-sh
  - dotfiles.copy-x11

"{{ slsdotpath }}-executor-rpc":
  file.recurse:
    - name: /usr/local/etc/qubes-rpc/
    - source: salt://{{ slsdotpath }}/files/server/rpc/
    - user: root
    - group: root
    - dir_mode: '0755'
    - file_mode: '0755'
    - makedirs: True

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
    - source: salt://{{ slsdotpath }}/files/server/builder.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

"{{ slsdotpath }}-executor-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: "mount /builder -o dev,suid,remount"

{% endif -%}
