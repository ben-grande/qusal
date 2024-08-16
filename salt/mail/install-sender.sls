{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

include:
  - utils.tools.common.update
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - dotfiles.copy-net

"{{ slsdotpath }}-sender-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - skip_suggestions: True
    - install_recommends: False
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - man-db
      - msmtp
      - libgnutls30
      - libio-socket-ssl-perl
      - libnet-smtp-ssl-perl
      - libnet-ssleay-perl
      - libsasl2-2
      - libsasl2-modules
      - libsasl2-modules-db

"{{ slsdotpath }}-sender-rpc":
  file.managed:
    - name: /etc/qubes-rpc/qusal.MailEnqueue
    - source: salt://{{ slsdotpath }}/files/sender/rpc/qusal.MailEnqueue
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
