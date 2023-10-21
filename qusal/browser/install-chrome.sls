{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-common

{% from 'utils/macros/install-repo.sls' import install_repo -%}
{{ install_repo(sls_path, 'chrome') }}

{#
"{{ slsdotpath }}-google-chrome-repo":
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/chrome.asc] http://dl.google.com/linux/chrome/deb/
    - dist: {{ grains.get['oscodename'] }}
    - comps: main
    - key_url: salt://{{ slsdotpath }}/files/repo/chrome.asc
    - file: /etc/apt/sources.list.d/chrome.list
#}

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
