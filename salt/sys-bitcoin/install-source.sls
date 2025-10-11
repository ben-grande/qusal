{#
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - {{ slsdotpath }}.install-common
  - dotfiles.copy-ssh
  - dotfiles.copy-git
  - sys-git.install-client

"{{ slsdotpath }}-source-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - cmake
      - clang-{{ version.clang_version }}
      - ccache
      - help2man

{% set pkg = {
  'Debian': {
    'pkg': ['build-essential', 'pkg-config', 'python3', 'libevent-dev',
            'libboost-dev', 'libsqlite3-dev', 'libzmq3-dev'],
  },
  'RedHat': {
    'pkg': ['gcc-c++', 'make', 'python3', 'libevent-devel', 'boost-devel',
            'sqlite-devel', 'zeromq-devel'],
  },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-source-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% set pkg = {
    'Debian': {
      'pkg': ['qt6-base-dev', 'qt6-tools-dev', 'qt6-tools-dev-tools',
              'qt6-l10n-tools' , 'libgl-dev', 'libqrencode-dev', 'libxcb-cursor0'],
    },
    'RedHat': {
      'pkg': ['qt6-qtbase-devel', 'qt6-qttools-devel', 'xcb-util-cursor', 'qrencode-devel'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-source-qt-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
