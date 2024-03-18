{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - .home-cleanup
  - .install-python-tools
  - .install-salt-tools
  - dotfiles.copy-all
  - utils.tools.zsh
  - sys-pgp.install-client
  - sys-git.install-client
  - sys-ssh-agent.install-client

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      ## Necessary
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-networking
      - ca-certificates
      - git
      - gnupg2
      ## Usability
      - tmux
      - xclip
      - bash-completion
      ## Reading documentation
      - man-db
      - info
      - texinfo
      ## Searching files
      - file
      - tree
      - ripgrep
      - fzf
      ## Lint
      - pre-commit
      - precious
      - reuse
      - gitlint
      - pylint
      - yamllint
      # git-send-email
      - git-email
      - libemail-valid-perl
      - libmailtools-perl
      - libauthen-sasl-perl

{% set pkg = {
    'Debian': {
      'pkg': ['shellcheck', 'vim-nox', 'fd-find'],
    },
    'RedHat': {
      'pkg': ['passwd', 'fd-find', 'ShellCheck', 'vim-enhanced'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
