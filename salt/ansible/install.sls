{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-repo
  - utils.tools.common.update
  - dotfiles.copy-sh
  - dotfiles.copy-x11
  - sys-ssh.install
  - sys-ssh.install-client
  - ssh.install

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install-repo
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - ansible
      - ansible-lint
      - python3-argcomplete
      - python3-jmespath
      - qubes-core-agent-passwordless-root
      - bash-completion
      - man-db

{% set pkg = {
    'Debian': {
      'pkg': ['vim-nox', 'python3-selinux'],
    },
    'RedHat': {
      'pkg': ['vim-enhanced', 'vim-ansible'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
