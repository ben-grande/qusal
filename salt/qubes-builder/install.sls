{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dotfiles.copy-git
  - dotfiles.copy-net
  - dotfiles.copy-pgp
  - dotfiles.copy-sh
  - dotfiles.copy-ssh
  - dotfiles.copy-x11
  - sys-git.install-client
  - sys-pgp.install-client
  - sys-ssh-agent.install-client
  - docker.install
  - .install-qubes-executor

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      ## Minimal template dependencies
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      ## Dependencies: https://github.com/QubesOS/qubes-builderv2#dependencies
      - asciidoc
      - createrepo_c
      - devscripts
      - m4
      - mock
      - openssl
      - pacman
      - podman
      - python3-click
      - python3-docker
      - python3-jinja2-cli
      - python3-lxml
      - python3-packaging
      - python3-pathspec
      - python3-podman
      - python3-pyyaml
      - rb_libtorrent-examples
      - reprepro
      - rpm
      - rpm-sign
      - rsync
      - tree

"{{ slsdotpath }}-add-user-to-mock-group":
  group.present:
    - name: mock
    - addusers:
      - user

"{{ slsdotpath }}-add-gpg-program-verify-git-commits-using-builder-keyring":
  file.managed:
    - name: /usr/bin/gpg-qubes-builder
    - source: salt://{{ slsdotpath }}/files/client/bin/gpg-qubes-builder
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

{% endif -%}
