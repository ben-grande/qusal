{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install

## chsh is not in Fedora and usermod covers a wider range.
"{{ slsdotpath }}-change-user-shell-to-zsh":
  cmd.run:
    - name: usermod -s /bin/zsh user
    - runas: root
    - require:
      - sls: {{ slsdotpath }}.install

{% endif -%}