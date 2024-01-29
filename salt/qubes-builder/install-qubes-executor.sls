{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated-qubes-executor":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-qubes-executor":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - dnf-plugins-core
      - createrepo_c
      - debootstrap
      - devscripts
      - dpkg-dev
      - git
      - mock
      - pbuilder
      - which
      - perl-Digest-MD5
      - perl-Digest-SHA
      - python3-pyyaml
      - python3-sh
      - rpm-build
      - rpmdevtools
      - wget
      - python3-debian
      - reprepro
      - systemd-udev

"{{ slsdotpath }}-qubes-executor-add-user-to-mock-group":
  group.present:
    - name: mock
    - addusers:
      - user

{% endif -%}
