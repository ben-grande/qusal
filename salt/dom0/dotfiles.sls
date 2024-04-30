{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

{%- import slsdotpath ~ "/gui-user.jinja" as gui_user -%}

include:
  - dotfiles.copy-all

"{{ slsdotpath }}-xprofile-sourcer":
  file.managed:
    - name: {{ gui_user.gui_user_home }}/.config/autostart/xprofile.desktop
    - source: salt://{{ slsdotpath }}/files/autostart/xprofile.desktop
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}
    - mode: '0644'
    - makedirs: True

{% endif -%}
