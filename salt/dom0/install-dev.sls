{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

"{{ slsdotpath }}-dev-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-dev-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - vim
      - tmux
      - xclip
      - bash-completion
      - man-db
      - tree

{% endif -%}
