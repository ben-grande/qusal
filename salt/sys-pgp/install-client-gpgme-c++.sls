{#
SPDX-FileCopyrightText: 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

{% set pkg = {
  'Debian': {
    'pkg': ['libgpgmepp6'],
  },
  'RedHat': {
    'pkg': ['gpgmepp'],
  },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-client-installed-os-specific-gpgme-c++":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
