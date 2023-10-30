{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated-salt-tools":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-salt-tools":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - python3-pip
      - yamllint
      - ansible-lint

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
    - refresh: True
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
