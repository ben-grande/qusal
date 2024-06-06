{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11

"{{ slsdotpath }}-install-qubes-firewall":
  file.managed:
    - name: /rw/config/qubes-firewall.d/50-sys-cacher
    - source: salt://{{ slsdotpath }}/files/server/qubes-firewall.d/50-sys-cacher
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-bind-dirs":
  file.managed:
    - name: /rw/config/qubes-bind-dirs.d/50-sys-cacher.conf
    - source: salt://{{ slsdotpath }}/files/server/qubes-bind-dirs.d/50-sys-cacher.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
