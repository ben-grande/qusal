{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-git
  - dotfiles.copy-net
  - dotfiles.copy-pgp
  - dotfiles.copy-sh
  - dotfiles.copy-ssh
  - dotfiles.copy-x11

"{{ slsdotpath }}-makedir-src":
  file.directory:
    - name: /home/user/src
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-gnupg-home":
  file.directory:
    - name: /home/user/.gnupg/qubes-builder
    - user: user
    - group: user
    - mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-save-keys":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-gnupg-home"
    - name: /home/user/.gnupg/qubes-builder/download/
    - source: salt://{{ slsdotpath }}/files/client/keys/
    - user: user
    - group: user
    - file_mode: '0600'
    - dir_mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-import-keys":
  cmd.run:
    - require:
      - file: "{{ slsdotpath }}-save-keys"
    - name: gpg --status-fd=2 --homedir . --import download/*.asc
    - cwd: /home/user/.gnupg/qubes-builder
    - runas: user
    - success_stderr: IMPORT_OK

"{{ slsdotpath }}-import-ownertrust":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
    - name: gpg --homedir . --import-ownertrust download/otrust.txt
    - cwd: /home/user/.gnupg/qubes-builder
    - runas: user

"{{ slsdotpath }}-git-clone-builderv2":
  git.cloned:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
    - name: https://github.com/QubesOS/qubes-builderv2.git
    - target: /home/user/src/qubes-builderv2
    - user: user

"{{ slsdotpath }}-git-clone-infrastructure-mirrors":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
    - name: git submodule update --init
    - cwd: /home/user/src/qubes-builderv2
    - runas: user

"{{ slsdotpath }}-git-config-gpg.program-for-builder":
  git.config_set:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
      - git: "{{ slsdotpath }}-git-clone-builderv2"
    - name: gpg.program
    - value: gpg-qubes-builder
    - repo: /home/user/src/qubes-builderv2
    - user: user

"{{ slsdotpath }}-git-config-gpg.program-for-mirrors":
  git.config_set:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
      - cmd: "{{ slsdotpath }}-git-clone-infrastructure-mirrors"
    - name: gpg.program
    - value: gpg-qubes-builder
    - repo: /home/user/src/qubes-builderv2/qubesbuilder/plugins/publish/mirrors
    - user: user

"{{ slsdotpath }}-git-verify-HEAD-builderv2":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-git-clone-builderv2"
      - cmd: "{{ slsdotpath }}-import-ownertrust"
    - name: GNUPGHOME="$HOME/.gnupg/qubes-builder" git -c gpg.program=gpg2 verify-tag "$(git describe --tags --abbrev=0)"
    - cwd: /home/user/src/qubes-builderv2
    - runas: user

"{{ slsdotpath }}-git-verify-HEAD-infrastructure-mirrors":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-git-clone-infrastructure-mirrors"
      - cmd: "{{ slsdotpath }}-import-ownertrust"
    - name: GNUPGHOME="$HOME/.gnupg/qubes-builder" git -c gpg.program=gpg2 verify-commit "HEAD^{commit}"
    - cwd: /home/user/src/qubes-builderv2/qubesbuilder/plugins/publish/mirrors
    - runas: user

{% endif -%}
