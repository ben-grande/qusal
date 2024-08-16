{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-installed-qubes-executor":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - createrepo_c
      - debootstrap
      - devscripts
      - dnf-plugins-core
      - dpkg-dev
      - git
      - mock
      - pbuilder
      - perl-Digest-MD5
      - perl-Digest-SHA
      - pykickstart
      - python3-debian
      - python3-pyyaml
      - python3-sh
      - reprepro
      - rpm-build
      - rpmdevtools
      - systemd-udev
      - wget2
      - which

"{{ slsdotpath }}-qubes-executor-add-user-to-mock-group":
  group.present:
    - name: mock
    - addusers:
      - user

{% endif -%}
