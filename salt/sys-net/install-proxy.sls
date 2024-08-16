{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-proxy-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - socat

"{{ slsdotpath }}-proxy-rpc":
  file.recurse:
    - require:
      - pkg: "{{ slsdotpath }}-proxy-installed"
    - name: /etc/qubes-rpc/
    - source: salt://{{ slsdotpath }}/files/server/rpc
    - user: root
    - group: root
    - file_mode: '0755'
    - dir_mode: '0755'

{% endif %}
