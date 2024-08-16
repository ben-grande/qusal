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
  - dotfiles.copy-mutt
  - sys-pgp.install-client

"{{ slsdotpath }}-reader-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - skip_suggestions: True
    - install_recommends: False
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-app-shutdown-idle
      - qubes-pdf-converter
      - qubes-img-converter
      - man-db
      - vim
      - mutt
      - notmuch-mutt
      - w3m
      - less
      - urlview

"{{ slsdotpath }}-reader-symlink-msmtpq":
  file.symlink:
    - require:
      - pkg: "{{ slsdotpath }}-reader-installed"
    - name: /usr/bin/msmtpq
    - target: /usr/libexec/msmtp/msmtpq/msmtpq
    - force: True

"{{ slsdotpath }}-reader-symlink-msmtp-queue":
  file.symlink:
    - require:
      - pkg: "{{ slsdotpath }}-reader-installed"
    - name: /usr/bin/msmtp-queue
    - target: /usr/libexec/msmtp/msmtpq/msmtp-queue
    - force: True

"{{ slsdotpath }}-reader-rpc":
  file.managed:
    - name: /etc/qubes-rpc/qusal.MailFetch
    - source: salt://{{ slsdotpath }}/files/reader/rpc/qusal.MailFetch
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-reader-bin":
  file.managed:
    - name: /usr/bin/qusal-send-mail
    - source: salt://{{ slsdotpath }}/files/reader/bin/qusal-send-mail
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
