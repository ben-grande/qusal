{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-installed-salt-tools":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - python3-pip

{% set pkg = {
    'Debian': {
      'pkg': [],
    },
    'RedHat': {
      'pkg': ['salt-lint'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-salt-tools-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

# Fails because of cacher
{#
{% if grains['os_family']|lower != 'redhat' -%}
pip-installed-salt-tools:
  cmd.run:
    - name: python3 -m pip install --break-system-packages salt-lint
{% endif -%}
#}

{% endif %}
