{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-doc-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-doc-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - pandoc
      - ronn
      - groff
      - man-db
      - less
      {#
      {% if grains['os_family']|lower == 'debian' -%}
      {% elif grains['os_family']|lower == 'redhat' -%}
      {% endif -%}
      #}

{% endif -%}
