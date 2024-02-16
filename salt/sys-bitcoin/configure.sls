{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-sh

"{{ slsdotpath }}-bitcoind-configuration":
  file.recurse:
    - name: /home/user/.bitcoin/
    - source: salt://{{ slsdotpath }}/files/server/conf/
    - file_mode: '0600'
    - dir_mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-bitcoind-touch-local-configuration":
  file.managed:
    - name: /home/user/.bitcoin/conf.d/bitcoin.conf.local
    - mode: '0600'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-bitcoind-touch-rpcauth-configuration":
  file.managed:
    - name: /home/user/.bitcoin/conf.d/rpcauth.conf
    - mode: '0600'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-bitcoind-touch-listen-configuration":
  file.managed:
    - name: /home/user/.bitcoin/conf.d/listen.conf
    - mode: '0600'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
