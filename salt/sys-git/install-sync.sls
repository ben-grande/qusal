{#
SPDX-FileCopyrightText: 2025 The Qusal Community <https://github.com/ben-grande/qusal>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - {{ slsdotfile }}.install-client
  - sys-pgp.install-client
  - sys-ssh-agent.install-client
  - dotfiles.copy-git
  - dotfiles.copy-sh
  - dotfiles.copy-x11

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - curl
      - git
      - man-db

{% endif -%}
