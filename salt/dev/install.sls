{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  {%- if salt['qvm.exists']('sys-cacher') %}
  - sys-cacher.install-client
  {% endif %}
  - .home-cleanup
  - .install-python-tools
  - .install-salt-tools
  - dotfiles.copy-all
  - utils.tools.zsh
  - sys-pgp.install-client
  - sys-git.install-client
  - sys-ssh-agent.install-client

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
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
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
