{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-client-proxy

"{{ slsdotpath }}-updated-cryptsetup":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-cryptsetup":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - cryptsetup

{% endif -%}
