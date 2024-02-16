{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-onion-grater-add-bitcoind":
  cmd.run:
    - name: onion-grater-add bitcoind
    - runas: root

"{{ slsdotpath }}-systemd-restart-onion-grater":
  service.running:
    - name: onion-grater
    - enable: True
    - watch:
      - cmd: "{{ slsdotpath }}-onion-grater-add-bitcoind"

{% endif -%}
