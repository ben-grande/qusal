{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11
  - dotfiles.copy-ssh
  - sys-ssh-agent.install-client

{% endif -%}
