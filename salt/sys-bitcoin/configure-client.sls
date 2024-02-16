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

"{{ slsdotpath }}-client-desktop-applications":
  file.recurse:
    - name: /home/user/.local/share/applications/
    - source: salt://{{ slsdotpath }}/files/client/applications/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-client-autostart-desktop-applications":
  file.symlink:
    - name: /home/user/.config/autostart/bitcoin-qt.desktop
    - target: /home/user/.local/share/applications/bitcoin-qt.desktop
    - user: user
    - group: user
    - force: True
    - makedirs: True

"{{ slsdotpath }}-client-bitcoin-configuration":
  file.recurse:
    - name: /home/user/.bitcoin/
    - source: salt://{{ slsdotpath }}/files/client/conf/
    - file_mode: '0600'
    - dir_mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-client-bitcoin-touch-local-configuration":
  file.managed:
    - name: /home/user/.bitcoin/conf.d/bitcoin.conf.local
    - mode: '0600'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-client-bitcoin-makedir-wallets":
  file.directory:
    - name: /home/user/.bitcoin/wallets
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

{% endif -%}
