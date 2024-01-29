{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

"{{ slsdotpath }}-port-forward-script":
  file.managed:
    - name: /usr/local/bin/qvm-port-forward
    - source: salt://{{ slsdotpath }}/files/bin/qvm-port-forward
    - mode: "0755"
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
