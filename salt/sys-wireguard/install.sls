{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-qvpn-group":
  group.present:
    - name: qvpn
    - system: True

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - ca-certificates
      - iproute2
      - libnotify-bin
      - mate-notification-daemon
      - resolvconf
      - unzip
      - wireguard
      - curl
      - zenity

{% endif -%}
