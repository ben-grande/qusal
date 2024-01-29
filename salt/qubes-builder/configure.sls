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
  - docker.configure

"{{ slsdotpath }}-rpmmacros":
  file.managed:
    - name: /home/user/.rpmmacros
    - source: salt://{{ slsdotpath }}/files/client/rpmmacros
    - mode: '0644'
    - user: user
    - group: user

"{{ slsdotpath }}-makedir-src":
  file.directory:
    - name: /home/user/src
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-git-clone-builderv2":
  git.latest:
    - name: https://github.com/QubesOS/qubes-builderv2.git
    - target: /home/user/src/qubes-builderv2
    - user: user

"{{ slsdotpath }}-git-clone-infrastructure-mirrors":
  git.latest:
    - name: https://github.com/QubesOS/qubes-infrastructure-mirrors.git
    - target: /home/user/src/qubes-infrastructure-mirrors
    - user: user

"{{ slsdotpath }}-gnupg-home":
  file.directory:
    - name: /home/user/.gnupg/qubes-builder
    - user: user
    - group: user
    - mode: '0700'

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
      - git: "{{ slsdotpath }}-git-clone-infrastructure-mirrors"
      - cmd: "{{ slsdotpath }}-import-ownertrust"
    - name: GNUPGHOME="$HOME/.gnupg/qubes-builder" git -c gpg.program=gpg2 verify-commit "HEAD^{commit}"
    - cwd: /home/user/src/qubes-infrastructure-mirrors
    - runas: user

"{{ slsdotpath }}-build-infrastructure-mirrors":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-git-verify-HEAD-infrastructure-mirrors"
    - name: sudo python3 setup.py build
    - cwd: /home/user/src/qubes-infrastructure-mirrors
    - runas: user

"{{ slsdotpath }}-install-infrastructure-mirrors":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-build-infrastructure-mirrors"
    - name: sudo python3 setup.py install
    - cwd: /home/user/src/qubes-infrastructure-mirrors
    - runas: user

{% endif -%}
