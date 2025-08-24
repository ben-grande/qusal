{#
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{#
ElectRS dependencies might break builds in case they don't set correct Cargo
properties to rebuild if a previously statically linked build was done.
See: https://github.com/romanz/electrs/issues/1001
#}
{% set electrs_obj_type = 'tag' -%}
{% if electrs_obj_type == 'commit' -%}
{% set electrs_obj = '1d9c4b8bb6fef23b128961fd6cdb291c52025010' -%}
{% else -%}
  {% set electrs_obj = 'v0.10.10' -%}
{% endif -%}

{% set cfg_me_version = '0.1.1' -%}

{% set cargo_opts = '' -%}
{% if salt['file.file_exists']('/usr/share/whonix/marker') -%}
  {% set cargo_opts = '--config net.git-fetch-with-cli=true --config http.proxy=\"socks5h://10.152.152.10:9400\"' -%}
{% endif -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-sh

"{{ slsdotpath }}-source-gnupg-home":
  file.directory:
    - name: /home/user/.gnupg/electrs
    - user: user
    - group: user
    - mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-source-save-keys":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-source-gnupg-home"
    - name: /home/user/.gnupg/electrs/download/
    - source: salt://{{ slsdotpath }}/files/server/keys/
    - user: user
    - group: user
    - file_mode: '0600'
    - dir_mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-source-import-keys":
  cmd.run:
    - require:
      - file: "{{ slsdotpath }}-source-save-keys"
    - name: gpg --homedir . --import download/*.asc
    - cwd: /home/user/.gnupg/electrs
    - runas: user

"{{ slsdotpath }}-source-import-ownertrust":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-import-keys"
    - name: gpg --homedir . --import-ownertrust download/otrust.txt
    - cwd: /home/user/.gnupg/electrs
    - runas: user

"{{ slsdotpath }}-source-makedir-src":
  file.directory:
    - name: /home/user/src
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-source-git-clone":
  git.latest:
    - name: https://github.com/romanz/electrs
    - target: /home/user/src/electrs
    - user: user
    - force_fetch: True

"{{ slsdotpath }}-source-git-verify-{{ electrs_obj_type }}-{{ electrs_obj }}":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-source-git-clone"
      - cmd: "{{ slsdotpath }}-source-import-ownertrust"
    - env:
      - GNUPGHOME: "/home/user/.gnupg/electrs"
    - name: git -c gpg.program=gpg2 verify-{{ electrs_obj_type }} "{{ electrs_obj }}"
    - cwd: /home/user/src/electrs
    - runas: user

"{{ slsdotpath }}-source-git-checkout-{{ electrs_obj_type }}-{{ electrs_obj }}":
  cmd.run:
    - name: git checkout {{ electrs_obj }}
    - require:
      - cmd: "{{ slsdotpath }}-source-git-verify-{{ electrs_obj_type }}-{{ electrs_obj }}"
    - cwd: /home/user/src/electrs
    - runas: user

"{{ slsdotpath }}-source-build-release":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-git-checkout-{{ electrs_obj_type }}-{{ electrs_obj }}"
    - env:
      - ROCKSDB_INCLUDE_DIR: /usr/include
      - ROCKSDB_LIB_DIR: /usr/lib
    - name: cargo {{ cargo_opts }} build --locked --release --no-default-features
    - cwd: /home/user/src/electrs
    - runas: user

"{{ slsdotpath }}-source-install-cfg_me":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-release"
    - name: cargo {{ cargo_opts }} install --root ~/.local --version {{ cfg_me_version }} cfg_me
    - runas: user

"{{ slsdotpath }}-source-build-manpages":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-install-cfg_me"
    - name: /home/user/.local/bin/cfg_me -o /tmp/electrs.1 man
    - cwd: /home/user/src/electrs
    - runas: user

"{{ slsdotpath }}-copy-files-to-template":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-source-build-release"
    - name: qrexec-client-vm -T -- @default qusal.InstallElectrs /usr/lib/qubes/qfile-agent target/release/electrs /tmp/electrs.1
    - cwd: /home/user/src/electrs
    - runas: user

{% endif -%}
