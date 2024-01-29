{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.zsh.install

## chsh is not in Fedora and usermod covers a wider range.
"{{ slsdotpath }}-change-user-shell-to-zsh":
  cmd.run:
    - name: usermod -s /bin/zsh user
    - runas: root
    - require:
      - sls: {{ slsdotpath }}.install

{% endif -%}
