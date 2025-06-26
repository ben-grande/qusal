{#
SPDX-FileCopyrightText: 2019 Frederic Pierret <frederic.pierret@qubes-os.org>
SPDX-FileCopyrightText: 2020 - 2024 Marmarek Marczykowski-Gorecki <marmarek@invisiblethingslab.com>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-2.0-only

Upstream pkg.installed install weak_deps/recommends.
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - sys-gui.install

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: sys-gui.install
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - pciutils
      - lshw
      - linux-firmware
      - amd-gpu-firmware
      - amd-ucode-firmware
      - xorg-x11-drv-amdgpu
      - radeontop
      - nvidia-gpu-firmware
      - libva-nvidia-driver
      - xorg-x11-drv-nouveau
      - intel-gpu-firmware
      - libva-intel-hybrid-driver
      - libva-intel-media-driver
      - xorg-x11-drv-intel

{% endif -%}
