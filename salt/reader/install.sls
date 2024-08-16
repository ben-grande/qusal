{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-pdf-converter
      - qubes-img-converter
      - qubes-core-agent-networking
      - ca-certificates
      - firefox-esr
      - qubes-core-agent-thunar
      - thunar
      - libreoffice
      - antiword
      - evince
      - python3-pdfminer
      - vim
      - man-db

{% endif -%}
