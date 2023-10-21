{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
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
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-networking
      - ca-certificates
      - git
      - gnupg2
      - tmux
      - xclip
      - bash-completion
      - man-db
      - texinfo
      - file
      - tree
      - pre-commit
      - gitlint
      - ripgrep
      - fzf
      {% if grains['os_family']|lower == 'debian' -%}
      - shellcheck
      - vim-nox
      - fd-find
      {% elif grains['os_family']|lower == 'redhat' -%}
      - passwd
      - fd-find
      - ShellCheck
      - vim-enhanced
      {% else -%}
      - fd
      - shellcheck
      - vim
      {% endif -%}

{% endif -%}
