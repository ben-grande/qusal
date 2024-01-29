{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install
  - sys-usb.install-client-proxy

"{{ slsdotpath }}-bluetooth-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-bluetooth-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - blueman
      - libspa-0.2-bluetooth
      - firmware-iwlwifi

{% endif -%}
