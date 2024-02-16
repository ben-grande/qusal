{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-x11

"{{ slsdotpath }}-distro-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-distro-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - electrum
      - python3-pyqt5

{% endif -%}
