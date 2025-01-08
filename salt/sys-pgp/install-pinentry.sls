{#
SPDX-FileCopyrightText: 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

{% set pkg = {
  'Debian': {
    'pkg': ['pinentry-curses', 'pinentry-tty', 'pinentry-gnome3'],
  },
  'RedHat': {
    'pkg': ['pinentry', 'pinentry-tty', 'pinentry-gnome3'],
  },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific-pinentry":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
