{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

include:
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - dotfiles.copy-net

"{{ slsdotpath }}-fetcher-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-fetcher-installed":
  pkg.installed:
    - refresh: True
    - skip_suggestions: True
    - install_recommends: False
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - man-db
      - offlineimap3
      - fdm
      - mpop
      - mb2md
      - libio-socket-ssl-perl
      - libnet-ssleay-perl
      - libsasl2-2
      - libsasl2-modules
      - libsasl2-modules-db

"{{ slsdotpath }}-fetcher-systemd-fdm.timer":
  file.managed:
    - name: /usr/lib/systemd/user/fdm.timer
    - source: salt://{{ slsdotpath }}/files/fetcher/systemd/fdm.timer
    - mode: "0644"
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-fetcher-systemd-fdm.service":
  file.managed:
    - name: /usr/lib/systemd/user/fdm.service
    - source: salt://{{ slsdotpath }}/files/fetcher/systemd/fdm.service
    - mode: "0644"
    - user: root
    - group: root
    - makedirs: true

"{{ slsdotpath }}-fetcher-bin":
  file.managed:
    - name: /usr/bin/qusal-send-inbox
    - source: salt://{{ slsdotpath }}/files/fetcher/bin/qusal-send-inbox
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
