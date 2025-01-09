{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{%- import "dom0/gui-user.jinja" as gui_user -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-pgp

"{{ slsdotpath }}-split-gpg2-conf.d":
  file.directory:
    - name: {{ gui_user.gui_user_home }}/.config/qubes-split-gpg2/conf.d
    - mode: "0700"
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}
    - makedirs: True

"{{ slsdotpath }}-split-gpg2-conf":
  file.managed:
    - name: {{ gui_user.gui_user_home }}/.config/qubes-split-gpg2/qubes-split-gpg2.conf
    - source: salt://{{ slsdotpath }}/files/server/qubes-split-gpg2.conf
    - mode: "0600"
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}
    - makedirs: True

{% endif -%}
