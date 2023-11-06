{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-common

{% from 'utils/macros/install-repo.sls' import install_repo -%}
{{ install_repo(sls_path, 'chrome') }}

"{{ slsdotpath }}-avoid-chrome-installing-own-repo":
  file.touch:
    - name: /etc/default/google-chrome

"{{ slsdotpath }}-updated-chrome":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-chrome":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - google-chrome-stable

{% endif -%}
