{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

include:
  - dotfiles.copy-all

"{{ slsdotpath }}-xprofile-sourcer":
  file.managed:
    - name: /home/user/.config/autostart/xprofile.desktop
    - source: salt://{{ slsdotpath }}/files/autostart/xprofile.desktop
    - user: user
    - group: user
    - mode: '0644'
    - makedirs: True

{% endif -%}
