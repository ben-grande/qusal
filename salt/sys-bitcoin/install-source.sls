{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - .install-common
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
      - clang
      - ccache
      - help2man

{% set pkg = {
  'Debian': {
    'pkg': ['build-essential', 'libtool', 'autotools-dev', 'automake',
            'pkg-config', 'bsdmainutils', 'python3', 'libevent-dev',
            'libboost-dev', 'libsqlite3-dev', 'libzmq3-dev'],
  },
  'RedHat': {
    'pkg': ['gcc-c++', 'libtool', 'make', 'autoconf', 'automake', 'python3',
            'libevent-devel', 'boost-devel', 'sqlite-devel', 'zeromq-devel'],
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
      'pkg': ['qtbase5-dev', 'qttools5-dev',
              'qttools5-dev-tools', 'libqrencode-dev'],
    },
    'RedHat': {
      'pkg': ['qt5-qttools-devel', 'qt5-qtbase-devel', 'qrencode-devel'],
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
