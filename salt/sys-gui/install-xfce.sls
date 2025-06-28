{#
SPDX-FileCopyrightText: 2019 Frederic Pierret <frederic.pierret@qubes-os.org>
SPDX-FileCopyrightText: 2020 - 2024 Marmarek Marczykowski-Gorecki <marmarek@invisiblethingslab.com>
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-2.0-only

Upstream pkg.installed installs weak_deps/recommends.
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - {{ slsdotpath }}.install

"{{ slsdotpath }}-installed-xfce":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      # Xfce related packages
      - arc-theme
      - xdg-user-dirs-gtk
      - xfce4-appfinder
      - xfce4-datetime-plugin
      - xfce4-panel
      - xfce4-places-plugin
      - xfce4-power-manager
      - xfce4-pulseaudio-plugin
      - xfce4-session
      - xfce4-settings
      - xfce4-settings-qubes
      - xfce4-taskmanager
      - xfce4-terminal
      - xfconf
      - xfwm4

{% set pkg = {
  'Debian': {
    'pkg': ['blackbird-gtk-theme', 'gnome-themes-standard',
            'greybird-gtk-theme', 'gtk3-engines-xfce', 'libxfce4ui-utils',
            'xfce4-screenshooter', 'xfdesktop4']
  },
  'RedHat': {
    'pkg': ['adwaita-gtk2-theme', 'adwaita-icon-theme', 'greybird-dark-theme',
            'greybird-light-theme', 'greybird-xfce4-notifyd-theme',
            'greybird-xfwm4-theme', 'gtk-xfce-engine',
            'xfce4-about', 'xfce4-screenshooter-plugin', 'xfdesktop',
            'xfwm4-themes']
  },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-xfce-os-specific":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
