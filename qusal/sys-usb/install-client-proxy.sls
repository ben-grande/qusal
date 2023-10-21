{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated-proxy":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-proxy":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-usb-proxy

{% endif -%}
