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

{% endif -%}
