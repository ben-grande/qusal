{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-2.0-only
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - sys-gui.install

{% endif -%}
