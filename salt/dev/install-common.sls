{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - {{ slsdotpath }}.home-cleanup
  - dotfiles.copy-all
  - utils.tools.zsh
  - sys-pgp.install-client
  - sys-git.install-client
  - sys-ssh-agent.install-client

"{{ slsdotpath }}-installed-common":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      ## Necessary
      - qubes-core-agent-passwordless-root
      - ca-certificates
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
      - gitlint

## Fedora doesn't have: ruby-mdl (markdownlint, mdl)
{% set pkg = {
    'Debian': {
      'pkg': ['shellcheck', 'vim-nox', 'fd-find', 'ruby-mdl'],
    },
    'RedHat': {
      'pkg': ['ShellCheck', 'vim-enhanced', 'fd-find', 'passwd'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific-common":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
