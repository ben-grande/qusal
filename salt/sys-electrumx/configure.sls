{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - whonix-workstation.configure-offline

"{{ slsdotpath }}-electrumx-configuration":
  file.recurse:
    - name: /home/user/.electrumx/
    - source: salt://{{ slsdotpath }}/files/server/conf/
    - file_mode: '0600'
    - dir_mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-electrumx-configuration-dir":
  file.directory:
    - name: /home/user/.electrumx/conf.d
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-electrumx-local-configuration":
  file.managed:
    - name: /home/user/.electrumx/conf.d/electrumx.conf.local
    - mode: '0600'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
