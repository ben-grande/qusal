{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{%- import slsdotpath ~ "/version.jinja" as version -%}

{% set bitcoin_tag = 'v' ~ version.version -%}

include:
  - .configure-builder-common

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

"{{ slsdotpath }}-source-build-autogen":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-git-checkout-tag-{{ bitcoin_tag }}"
    - name: ./autogen.sh
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-configure":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-autogen"
    - env:
      - CXX: "clang++"
      - CC: "clang"
    - name: |
        ./configure \
          --prefix=/home/user/bitcoin-build \
          --disable-maintainer-mode \
          --disable-tests \
          --disable-bench \
          --disable-fuzz-binary \
          --disable-shared \
          --disable-dependency-tracking \
          --without-miniupnpc \
          --without-natpmp \
          --without-bdb \
          --without-libs
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-make-clean":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-configure"
    - name: make clean
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-make":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make-clean"
    - name: make -j "$(($(nproc)+1))"
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-gen-manpages":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make"
    - name: ./contrib/devtools/gen-manpages.py
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-gen-bitcoin-conf":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make"
    - name: ./contrib/devtools/gen-bitcoin-conf.sh
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-build-make-install":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make"
    - name: make install
    - cwd: /home/user/src/bitcoin
    - runas: user

"{{ slsdotpath }}-source-readme":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make-install"
    - name: |
        \mkdir -p -- share/bitcoin
        \cp -v -- ~/src/bitcoin/README.md share/bitcoin/
    - cwd: /home/user/bitcoin-build
    - runas: user

"{{ slsdotpath }}-source-share-examples":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make-install"
    - name: |
        \cp -v -- ~/src/bitcoin/share/examples/bitcoin.conf bitcoin.conf
    - cwd: /home/user/bitcoin-build
    - runas: user

"{{ slsdotpath }}-source-shell-completion":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make-install"
    - name: |
        \mkdir -p -- share/bash-completion/completions/
        \cp -v -- ~/src/bitcoin/contrib/completions/bash/* share/bash-completion/completions/
    - cwd: /home/user/bitcoin-build
    - runas: user

"{{ slsdotpath }}-source-rpcauth":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make-install"
    - name: |
        \mkdir -p -- share/rpcauth
        \cp -v -- ~/src/bitcoin/share/rpcauth/rpcauth.py share/rpcauth/
    - cwd: /home/user/bitcoin-build
    - runas: user

"{{ slsdotpath }}-source-rpcauth":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make-install"
    - name: |
        \mkdir -p -- share/icons/hicolor/scalable/apps/
        \cp -v -- ~/src/bitcoin/src/qt/res/src/bitcoin.svg share/icons/hicolor/scalable/apps/
    - cwd: /home/user/bitcoin-build
    - runas: user

"{{ slsdotpath }}-source-copy-files-to-template":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-make"
    - name: qrexec-client-vm -T -- @default qusal.InstallBitcoin /usr/lib/qubes/qfile-agent /home/user/bitcoin-build/*
    - runas: user

{% endif -%}
