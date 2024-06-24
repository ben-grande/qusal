{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

"{{ slsdotpath }}-terminal-helper":
  file.managed:
    - name: /usr/local/bin/qvm-terminal
    - source: salt://{{ slsdotpath }}/files/bin/qvm-terminal
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-file-manager-helper":
  file.symlink:
    - require:
      - file: "{{ slsdotpath }}-terminal-helper"
    - name: /usr/local/bin/qvm-file-manager
    - target: /usr/local/bin/qvm-terminal
    - user: root
    - group: root
    - force: True
    - makedirs: True

"{{ slsdotpath }}-copy-to-dom0-helper":
  file.managed:
    - name: /usr/local/bin/qvm-copy-to-dom0
    - source: salt://{{ slsdotpath }}/files/bin/qvm-copy-to-dom0
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-mgmt-debug-helper":
  file.managed:
    - name: /usr/local/bin/qvm-mgmt
    - source: salt://{{ slsdotpath }}/files/bin/qvm-mgmt
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
