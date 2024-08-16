{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

{%- import slsdotpath ~ "/gui-user.jinja" as gui_user -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-desktop-kde-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - setopt: "install_weak_deps=False"
    - pkgs:
      - kde-settings-qubes
      - sddm

"{{ slsdotpath }}-desktop-kde-configure-xinit":
  file.managed:
    - name: /etc/X11/xinit/xinitrc.d/55xfce-qubes.sh
    - source: salt://{{ slsdotpath }}/files/xinitrc.d/55xfce-qubes.sh
    - user: root
    - group: root
    - mode: '0755'

"{{ slsdotpath }}-desktop-kde-configure-sddm":
  file.managed:
    - name: /etc/sddm.conf.d/qubes.conf
    - source: salt://{{ slsdotpath }}/files/sddm.conf.d/qubes.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

"{{ slsdotpath }}-desktop-kde-disable-lightdm":
  cmd.run:
    - name: systemctl disable lightdm
    - runas: root
    - require:
      - pkg: {{ slsdotpath }}-desktop-kde-installed

"{{ slsdotpath }}-desktop-kde-enable-sddm":
  cmd.run:
    - name: systemctl enable sddm
    - runas: root
    - require:
      - cmd: {{ slsdotpath }}-desktop-kde-disable-lightdm

"{{ slsdotpath }}-desktop-kde-activity-notifier":
  file.managed:
    - name: {{ gui_user.gui_user_home }}/.config/autostart-scripts/kde-activity-changed-notifier
    - source: salt://{{ slsdotpath }}/files/autostart-scripts/kde-activity-changed-notifier
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-desktop-kde-qubes-kde-win-rules":
  file.managed:
    - name: {{ gui_user.gui_user_home }}/.local/bin/qubes-kde-win-rules
    - source: salt://{{ slsdotpath }}/files/bin/qubes-kde-win-rules
    - user: {{ gui_user.gui_user }}
    - group: {{ gui_user.gui_user }}
    - mode: '0755'
    - makedirs: True

{% endif -%}
