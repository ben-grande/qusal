{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.install-common
  - dev.install-python-tools

"{{ slsdotpath }}-installed-qusal":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - yamllint
      - codespell
      - pre-commit
      - reuse

## Debian doesn't have: salt-lint
{% set pkg = {
    'Debian': {
      'pkg': [],
    },
    'RedHat': {
      'pkg': ['salt-lint'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific-qusal":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
