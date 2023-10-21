{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
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

"{{ slsdotpath }}-gpg-split-domain":
  file.managed:
    - name: /rw/config/gpg-split-domain
    - source: salt://{{ slsdotpath }}/files/qubes-builder/gpg-split-domain
    - mode: '0644'
    - user: root
    - group: root

"{{ slsdotpath }}-rpmmacros":
  file.managed:
    - name: /home/user/.rpmmacros
    - source: salt://{{ slsdotpath }}/files/qubes-builder/rpmmacros
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

"{{ slsdotpath }}-gnupg-home-for-builder":
  file.directory:
    - name: /home/user/.gnupg/qubes-builder
    - user: user
    - group: user
    - mode: '0700'

"{{ slsdotpath }}-keyring-and-trustdb":
  file.managed:
    - user: user
    - group: user
    - mode: '0600'
    - names:
      - /home/user/.gnupg/qubes-builder/pubring.kbx:
        - source: salt://{{ slsdotpath }}/files/keys/pubring.kbx
      - /home/user/.gnupg/qubes-builder/trustdb.gpg:
        - source: salt://{{ slsdotpath }}/files/keys/trustdb.gpg

"{{ slsdotpath }}-git-verify-HEAD-builderv2":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-git-clone-builderv2"
    - name: GNUPGHOME="$HOME/.gnupg/qubes-builder" git -c gpg.program=gpg2 verify-commit "HEAD^{commit}"
    - cwd: /home/user/src/qubes-builderv2
    - runas: user

"{{ slsdotpath }}-git-verify-HEAD-infrastructure-mirrors":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-git-clone-infrastructure-mirrors"
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
