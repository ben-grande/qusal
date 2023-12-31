{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - sys-usb.install-client-fido
  - sys-audio.install-client

"{{ slsdotpath }}-updated-common":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-common":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - qubes-core-agent-thunar
      - thunar
      - zenity
      - libgdk-pixbuf2.0-bin

{% endif -%}
