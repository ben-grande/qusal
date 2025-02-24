{#
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{% if grains['os_family']|lower == 'debian' -%}

"{{ slsdotpath }}-set-default-terminal-to-xterm":
  cmd.run:
    - name: update-alternatives --verbose --set x-terminal-emulator /usr/bin/xterm
    - runas: root

{% endif -%}

{% endif -%}
