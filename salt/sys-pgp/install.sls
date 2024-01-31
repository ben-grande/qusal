{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-pgp

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - split-gpg2
      - gnupg2

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
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
