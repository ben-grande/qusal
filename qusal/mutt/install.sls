{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

include:
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - dotfiles.copy-mutt

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
      - qubes-core-agent-networking
      - qubes-pdf-converter
      - qubes-img-converter
      - qubes-gpg-split
      - w3m
      - vim
      - man-db
      - less
      # mutt
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
      - libio-socket-ssl-perl

{% endif -%}
