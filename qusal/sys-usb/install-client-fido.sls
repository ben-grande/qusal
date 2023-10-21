{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-client-proxy

"{{ slsdotpath }}-updated-fido":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-fido":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-u2f
      #- qubes-ctap

{% endif -%}
