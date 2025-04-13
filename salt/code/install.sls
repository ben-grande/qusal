{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dev.home-cleanup
  - dotfiles.copy-all
  - utils.tools.zsh
  - sys-git.install-client

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      ## Necessary
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-networking
      - ca-certificates
      ## Usability
      - tmux
      - xclip
      - bash-completion
      ## File management
      - file
      - tree
      - ripgrep
      - fzf
      - zip
      ## internet stuff
      - curl
      - dnsutils
      ## Lint
      - pre-commit
      - precious
      - gitlint
      - pylint
      - yamllint
      - ruby-mdl
      - codespell

## Fedora doesn't have: ruby-mdl (markdownlint, mdl)
## Debian doesn't have: salt-lint
{% set pkg = {
    'Debian': {
      'pkg': ['shellcheck', 'fd-find'],
    },
    'RedHat': {
      'pkg': ['ShellCheck', 'fd-find', 'passwd'],
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
