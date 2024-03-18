{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-chrome-repo
  - .install-common

"{{ slsdotpath }}-avoid-chrome-installing-own-repo":
  file.touch:
    - name: /etc/default/google-chrome

"{{ slsdotpath }}-installed-chrome":
  pkg.installed:
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - google-chrome-stable

{% endif -%}
