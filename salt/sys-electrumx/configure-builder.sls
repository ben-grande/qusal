{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

## Last tag is too old, we will use commit instead.
{% set electrumx_obj_type = 'commit' -%}
{% if electrumx_obj_type == 'commit' -%}
  {% set electrumx_obj = '470c76d9161175237d9c32d1078d84f1c403ed27' -%}
{% else -%}
  {% set electrumx_obj = '1.16.0' -%}
{% endif -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-sh
  - dotfiles.copy-git

"{{ slsdotpath }}-makedir-src":
  file.directory:
    - name: /home/user/src
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-git-clone":
  git.latest:
    - name: https://github.com/spesmilo/electrumx
    - target: /home/user/src/electrumx
    - user: user
    - force_fetch: True

"{{ slsdotpath }}-gnupg-home":
  file.directory:
    - name: /home/user/.gnupg/electrumx
    - user: user
    - group: user
    - mode: '0700'

"{{ slsdotpath }}-save-keys":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-gnupg-home"
    - name: /home/user/.gnupg/electrumx/download/
    - source: salt://{{ slsdotpath }}/files/server/keys/
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
    - cwd: /home/user/.gnupg/electrumx
    - runas: user
    - success_stderr: IMPORT_OK

"{{ slsdotpath }}-import-ownertrust":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
    - name: gpg --homedir . --import-ownertrust download/otrust.txt
    - cwd: /home/user/.gnupg/electrumx
    - runas: user

"{{ slsdotpath }}-git-verify-{{ electrumx_obj_type }}-{{ electrumx_obj }}":
  cmd.run:
    - require:
      - git: "{{ slsdotpath }}-git-clone"
      - cmd: "{{ slsdotpath }}-import-ownertrust"
    - env:
      - GNUPGHOME: "/home/user/.gnupg/electrumx"
    - name: git -c gpg.program=gpg2 verify-{{ electrumx_obj_type }} "{{ electrumx_obj }}"
    - cwd: /home/user/src/electrumx
    - runas: user

"{{ slsdotpath }}-git-checkout-{{ electrumx_obj_type }}-{{ electrumx_obj }}":
  cmd.run:
    - name: git checkout {{ electrumx_obj }}
    - require:
      - cmd: "{{ slsdotpath }}-git-verify-{{ electrumx_obj_type }}-{{ electrumx_obj }}"
    - cwd: /home/user/src/electrumx
    - runas: user

"{{ slsdotpath }}-copy-files-to-template":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-git-checkout-{{ electrumx_obj_type }}-{{ electrumx_obj }}"
    - name: qrexec-client-vm -T -- @default qusal.InstallElectrumx /usr/lib/qubes/qfile-agent electrumx electrumx_rpc electrumx_server electrumx_compact_history
    - cwd: /home/user/src/electrumx
    - runas: user

{% endif -%}
