{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-firefox-repo
  - .install-common

"{{ slsdotpath }}-installed-firefox":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install-common
      - sls: {{ slsdotpath }}.install-firefox-repo
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - firefox

{% endif -%}
