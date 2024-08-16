{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dotfiles.copy-pgp

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - split-gpg2
      - gnupg2
      - man-db

{% set pkg = {
  'Debian': {
    'pkg': ['sq', 'sq-keyring-linter', 'sq-wot', 'sqop', 'sqv'],
  },
  'RedHat': {
    'pkg': ['sequoia-sq', 'sequoia-keyring-linter', 'sequoia-wot',
            'sequoia-sop', 'sequoia-sqv', 'sequoia-policy-config',
            'sequoia-chameleon-gnupg'],
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
