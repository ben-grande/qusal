{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

include:
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - dotfiles.copy-net
  - dotfiles.copy-mutt

"{{ slsdotpath }}-reader-mailcap":
  file.managed:
    - name: /home/user/.mailcap
    - source: salt://{{ slsdotpath }}/files/reader/mailcap
    - mode: "0644"
    - user: user
    - group: user
    - makedirs: True

{%- set qusal_dot = salt["pillar.get"]("qusal:dotfiles:all", default=True) -%}
{%- if salt["pillar.get"]("qusal:dotfiles:mutt", default=qusal_dot) -%}

"{{ slsdotpath }}-reader-mutt-offline":
  file.symlink:
    - require:
      - sls: dotfiles.copy-mutt
    - name: /home/user/.config/mutt/90_offline.muttrc
    - target: /home/user/.config/mutt/sample/offline.muttrc.example
    - user: user
    - group: user
    - force: True

{% endif -%}

{% endif -%}
