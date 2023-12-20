{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

include:
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - dotfiles.copy-net
  - dotfiles.copy-mutt
  - sys-pgp.install-client

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - skip_suggestions: True
    - install_recommends: False
    - pkgs:
      # general
      - qubes-app-shutdown-idle
      - qubes-core-agent-networking
      - qubes-pdf-converter
      - qubes-img-converter
      - w3m
      - man-db
      - less
      # mutt
      - vim
      - mutt
      - notmuch
      - notmuch-mutt
      - offlineimap3
      - mb2md
      - ca-certificates
      - libgnutls30
      - libio-socket-ssl-perl
      - libnet-smtp-ssl-perl
      - libnet-ssleay-perl
      - libsasl2-2
      - libsasl2-modules
      - libsasl2-modules-db
      # git-email
      - git-email
      - libemail-valid-perl
      - libmailtools-perl
      - libauthen-sasl-perl

{% endif -%}
