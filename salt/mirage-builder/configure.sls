{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{% set mirage_firewall_tag = 'v0.8.6' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-ssh
  - dotfiles.copy-git

"{{ slsdotpath }}-opam-completion-and-hooks":
  file.managed:
    - name: /home/user/.config/sh/profile.d/opam.sh
    - source: salt://{{ slsdotpath }}/files/client/profile/opam.sh
    - mode: '0755'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-makedir-src":
  file.directory:
    - name: /home/user/src
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-gnupg-home":
  file.directory:
    - name: /home/user/.gnupg/mirage-firewall
    - user: user
    - group: user
    - mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-save-keys":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-gnupg-home"
    - name: /home/user/.gnupg/mirage-firewall/download/
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
    - cwd: /home/user/.gnupg/mirage-firewall
    - runas: user
    - success_stderr: IMPORT_OK

"{{ slsdotpath }}-import-ownertrust":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
    - name: gpg --homedir . --import-ownertrust download/otrust.txt
    - cwd: /home/user/.gnupg/mirage-firewall
    - runas: user

"{{ slsdotpath }}-git-clone":
  git.latest:
    - name: https://github.com/mirage/qubes-mirage-firewall
    - target: /home/user/src/qubes-mirage-firewall
    - user: user
    - force_fetch: True

## The tag is annotated, using verify-commit instead.
"{{ slsdotpath }}-git-verify-tag":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-git-clone"
    - name: GNUPGHOME="$HOME/.gnupg/mirage-firewall" git -c gpg.program=gpg2 verify-commit {{ mirage_firewall_tag }}
    - cwd: /home/user/src/qubes-mirage-firewall
    - runas: user

"{{ slsdotpath }}-git-checkout-tag-{{ mirage_firewall_tag }}":
  cmd.run:
    - name: git checkout {{ mirage_firewall_tag }}
    - require:
      - cmd: "{{ slsdotpath }}-git-verify-tag"
    - cwd: /home/user/src/qubes-mirage-firewall
    - runas: user

"{{ slsdotpath }}-makedir-home-docker":
  file.directory:
    - name: /home/user/docker
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

{% if salt['grains.get']('os_family') == 'RedHat' -%}
"{{ slsdotpath }}-file-security-context":
  cmd.run:
    - name: chcon -Rt container_file_t /home/user/docker
    - require:
      - file: "{{ slsdotpath }}-makedir-home-docker"
    - runas: user
{% endif -%}

{% endif -%}
