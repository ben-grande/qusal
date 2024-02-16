{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

Source: https://github.com/romanz/electrs/blob/master/doc/install.md
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-builder-source

{% endif -%}
