{#
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{%- import slsdotpath ~ "/version.jinja" as version -%}

{% set bitcoin_tag = 'v' ~ version.version -%}

include:
  - {{ slsdotpath }}.configure-builder-common

"{{ slsdotpath }}-source-makedir-src":
  file.directory:
    - name: /home/user/src
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-source-git-clone":
  git.latest:
    - name: https://github.com/bitcoin/bitcoin
    - target: /home/user/src/bitcoin
    - depth: 1
    - rev: {{ bitcoin_tag }}
    - user: user
    - force_fetch: True

"{{ slsdotpath }}-source-git-verify-tag-{{ bitcoin_tag }}":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-source-git-clone"
      - cmd: "{{ slsdotpath }}-import-ownertrust"
    - env:
      - GNUPGHOME: "/home/user/.gnupg/bitcoin"
    - name: git -c gpg.program=gpg2 verify-tag "{{ bitcoin_tag }}"
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-git-checkout-tag-{{ bitcoin_tag }}":
  cmd.run:
    - name: git checkout {{ bitcoin_tag }}
    - require:
      - cmd: "{{ slsdotpath }}-source-git-verify-tag-{{ bitcoin_tag }}"
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-configure":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-git-checkout-tag-{{ bitcoin_tag }}"
    - name: |
        cmake \
          -B /home/user/bitcoin-build \
          -DCMAKE_INSTALL_PREFIX=/home/user/bitcoin-install \
          -DCMAKE_CXX_COMPILER=clang++-{{ version.clang_version }} \
          -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-O2 -g0" \
          -DCMAKE_C_COMPILER=clang-{{ version.clang_version }} \
          -DBUILD_BENCH=OFF \
          -DBUILD_CLI=ON \
          -DBUILD_DAEMON=ON \
          -DBUILD_FOR_FUZZING=OFF \
          -DBUILD_GUI=ON \
          -DBUILD_SHARED_LIBS=OFF \
          -DBUILD_TESTS=OFF \
          -DBUILD_TX=ON \
          -DBUILD_UTIL=ON \
          -DBUILD_UTIL_CHAINSTATE=ON \
          -DBUILD_WALLET_TOOL=ON \
          -DENABLE_EXTERNAL_SIGNER=ON \
          -DENABLE_HARDENING=ON \
          -DENABLE_WALLET=ON \
          -DWITH_BDB=OFF \
          -DWITH_CCACHE=ON \
          -DWITH_MINIUPNPC=OFF \
          -DWITH_SQLITE=ON \
          -DWITH_USDT=OFF \
          -DWITH_ZMQ=ON
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-execute":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-configure"
    - name: |
        cmake \
          --build /home/user/bitcoin-build \
          --parallel "$(($(nproc)+1))" \
          --clean-first
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-gen-manpages":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-execute"
    - env:
      - BUILDDIR: "/home/user/bitcoin-build"
    - name: ./contrib/devtools/gen-manpages.py
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-gen-bitcoin-conf":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-execute"
    - env:
      - BUILDDIR: "/home/user/bitcoin-build"
    - name: ./contrib/devtools/gen-bitcoin-conf.sh
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-install":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-execute"
    - name: cmake --install /home/user/bitcoin-build
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-readme":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-install"
    - name: |
        \mkdir -p -- share/bitcoin
        \cp -v -- ~/src/bitcoin/README.md share/bitcoin/
    - cwd: /home/user/bitcoin-install
    - runas: user

"{{ slsdotpath }}-source-share-examples":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-install"
    - name: |
        \cp -v -- ~/src/bitcoin/share/examples/bitcoin.conf bitcoin.conf
    - cwd: /home/user/bitcoin-install
    - runas: user

"{{ slsdotpath }}-source-shell-completion":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-install"
    - name: |
        \mkdir -p -- share/bash-completion/completions/
        \cp -v -- ~/src/bitcoin/contrib/completions/bash/* share/bash-completion/completions/
    - cwd: /home/user/bitcoin-install
    - runas: user

"{{ slsdotpath }}-source-rpcauth":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-install"
    - name: |
        \mkdir -p -- share/rpcauth
        \cp -v -- ~/src/bitcoin/share/rpcauth/rpcauth.py share/rpcauth/
    - cwd: /home/user/bitcoin-install
    - runas: user

"{{ slsdotpath }}-source-gui-icons":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-install"
    - name: |
        \mkdir -p -- share/icons/hicolor/scalable/apps/
        \cp -v -- ~/src/bitcoin/src/qt/res/src/bitcoin.svg share/icons/hicolor/scalable/apps/
    - cwd: /home/user/bitcoin-install
    - runas: user

"{{ slsdotpath }}-source-copy-files-to-template":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-install"
    - name: qrexec-client-vm -T -- @default qusal.InstallBitcoin /usr/lib/qubes/qfile-agent /home/user/bitcoin-install/*
    - runas: user

{% endif -%}
