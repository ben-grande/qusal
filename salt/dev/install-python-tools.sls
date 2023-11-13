{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated-python-tools":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-python-tools":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - python3-dev
      - python3-venv
      - python3-setuptools
      - python3-pytest
      - python3-pip

{% endif %}
