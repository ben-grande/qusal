{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-x11
  - sys-pgp.install-client

"{{ slsdotpath }}-builder-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-builder-installed":
  pkg.installed:
    - require:
      - pkg: "{{ slsdotpath }}-builder-updated"
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - curl
      - tar
      - protobuf-compiler

{% endif -%}
