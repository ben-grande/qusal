{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkg:
      - vim
      - xclip

"{{ slsdotpath }}-qubes-update-script":
  file.managed:
    - name: /usr/local/bin/qubes-update
    - source: salt://{{ slsdotpath }}/files/bin/qubes-update
    - mode: '0755'
    - user: root
    - group: root

{% endif -%}
