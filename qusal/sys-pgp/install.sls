{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-pgp

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - split-gpg2
      - qubes-gpg-split
      - gnupg2
      {% if grains['os_family']|lower == 'debian' -%}
      - sq
      {% elif grains['os_family']|lower == 'redhat' -%}
      - sequoia-sq
      {% endif -%}

{% endif -%}
