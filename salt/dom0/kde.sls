{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

"{{ slsdotpath }}-kde-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-kde-installed":
  pkg.installed:
    - pkgs:
      - kde-settings-qubes
      - sddm

"{{ slsdotpath }}-configure-xinit":
  file.managed:
    - name: /etc/X11/xinit/xinitrc.d/55xfce-qubes.sh
    - source: salt://{{ slsdotpath }}/files/xinitrc.d/55xfce-qubes.sh
    - user: root
    - group: root
    - mode: '0755'

"{{ slsdotpath }}-configure-sddm":
  file.managed:
    - name: /etc/sddm.conf.d/qubes.conf
    - source: salt://{{ slsdotpath }}/files/sddm.conf.d/qubes.conf
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: True

"{{ slsdotpath }}-disable-lightdm":
  cmd.run:
    - name: systemctl disable lightdm
    - runas: root
    - require:
      - pkg: {{ slsdotpath }}-kde-installed

"{{ slsdotpath }}-enable-sddm":
  cmd.run:
    - name: systemctl enable sddm
    - runas: root
    - require:
      - cmd: {{ slsdotpath }}-disable-lightdm

"{{ slsdotpath }}-activity-notifier":
  file.managed:
    - name: /home/user/.config/autostart-scripts/kde-activity-changed-notifier
    - source: salt://{{ slsdotpath }}/files/autostart-scripts/kde-activity-changed-notifier
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-qubes-kde-win-rules":
  file.managed:
    - name: /home/user/.local/bin/qubes-kde-win-rules
    - source: salt://{{ slsdotpath }}/files/bin/qubes-kde-win-rules
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

{% endif -%}
