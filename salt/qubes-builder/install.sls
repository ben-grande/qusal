{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
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

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      ## Goodies
      - rpmautospec
      - rpmlint
      - vim-enhanced
      ## Minimal template dependencies
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      ## Undocumented Infraestructure Mirrors dependencies
      - python3-lxml
      ## Undocumented Builder dependencies
      - python3-click
      ## Dependencies: https://github.com/QubesOS/qubes-builderv2#dependencies
      - asciidoc
      - createrepo_c
      - devscripts
      - m4
      - mktorrent
      - mock
      - openssl
      - pacman
      - podman
      - python3-docker
      - python3-jinja2-cli
      - python3-packaging
      - python3-pathspec
      - python3-podman
      - python3-pyyaml
      - reprepro
      - rpm
      - rpm-sign
      - rsync
      - tree

{% endif -%}
