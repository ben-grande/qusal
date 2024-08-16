{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

Source: https://github.com/romanz/electrs/blob/master/doc/install.md
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - sys-git.install-client
  - sys-pgp.install-client

"{{ slsdotpath }}-builder-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
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
