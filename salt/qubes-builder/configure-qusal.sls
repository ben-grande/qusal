{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .configure

"{{ slsdotpath }}-makedir-qusal-builder":
  file.directory:
    - name: /home/user/src/qusal-builder
    - user: user
    - group: user
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-qusal-save-configuration":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-makedir-qusal-builder"
    - name: /home/user/src/qusal-builder
    - source: salt://{{ slsdotpath }}/files/client/qusal/
    - user: user
    - group: user
    - file_mode: '0644'
    - dir_mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-qusal-gnupg-home":
  file.directory:
    - name: /home/user/.gnupg/qusal-builder
    - user: user
    - group: user
    - mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-qusal-save-keys":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-qusal-gnupg-home"
    - name: /home/user/.gnupg/qusal-builder/download/
    - source: salt://{{ slsdotpath }}/files/client/qusal/keys/
    - user: user
    - group: user
    - file_mode: '0600'
    - dir_mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-qusal-import-keys":
  cmd.run:
    - require:
      - file: "{{ slsdotpath }}-qusal-save-keys"
    - name: gpg --status-fd=2 --homedir . --import download/*.asc
    - cwd: /home/user/.gnupg/qusal-builder
    - runas: user
    - success_stderr: IMPORT_OK

"{{ slsdotpath }}-qusal-import-ownertrust":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-qusal-import-keys"
    - name: gpg --homedir . --import-ownertrust download/otrust.txt
    - cwd: /home/user/.gnupg/qusal-builder
    - runas: user

{% endif -%}
