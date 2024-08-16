{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-xorg-allow-custom-xsession-login":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - setopt: "install_weak_deps=False"
    - pkgs:
      - xorg-x11-xinit-session

"{{ slsdotpath }}-xorg-tap-to-touch":
  file.managed:
    - name: /etc/X11/xorg.conf.d/30-touchpad.conf
    - source: salt://{{ slsdotpath }}/files/xorg.conf.d/30-touchpad.conf
    - user: root
    - group: root
    - mode: '0644'

{% endif -%}
