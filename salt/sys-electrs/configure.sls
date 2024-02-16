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

"{{ slsdotpath }}-bitcoin-data-directory":
  file.directory:
    - name: /home/user/.bitcoin
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-electrs-configuration":
  file.recurse:
    - name: /home/user/.electrs/
    - source: salt://{{ slsdotpath }}/files/server/conf/
    - file_mode: '0600'
    - dir_mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-electrs-configuration-directory":
  file.directory:
    - name: /home/user/.electrs/conf.d
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
