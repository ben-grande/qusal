{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
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

{% endif -%}
