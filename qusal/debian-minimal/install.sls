{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' and grains['os_family']|lower == 'debian' -%}

include:
  - dotfiles.copy-x11
  - dev.home-cleanup

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-configure-locale":
  file.replace:
    - name: /etc/locale.gen
    - pattern: '# en_US.UTF-8 UTF-8'
    - repl: 'en_US.UTF-8 UTF-8'

"{{ slsdotpath }}-generate-locale":
  cmd.run:
    - name: /usr/sbin/locale-gen
    - runas: root

{% endif -%}
