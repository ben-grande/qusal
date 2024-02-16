{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

Source: https://github.com/romanz/electrs/blob/master/doc/install.md
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - sys-git.install-client
  - sys-pgp.install-client

"{{ slsdotpath }}-builder-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-builder-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - man-db
      - cargo
      - librocksdb-dev
      - clang
      - cmake
      - build-essential

{% endif -%}
