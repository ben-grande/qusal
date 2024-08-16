{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-mullvad-repo
  - .install-common

"{{ slsdotpath }}-installed-mullvad":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install-common
      - sls: {{ slsdotpath }}.install-mullvad-repo
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - mullvad-browser

"{{ slsdotpath }}-mullvad-copy-desktop-application":
  file.copy:
    - require:
      - pkg: "{{ slsdotpath }}-installed-mullvad"
    - name: /usr/share/applications/qusal-mullvad-browser.desktop
    - source: /usr/share/applications/mullvad-browser.desktop
    - user: root
    - group: root
    - mode: "0644"
    - force: True

"{{ slsdotpath }}-mullvad-do-not-detach-from-desktop-application":
  file.replace:
    - require:
      - file: "{{ slsdotpath }}-mullvad-copy-desktop-application"
    - name: /usr/share/applications/qusal-mullvad-browser.desktop
    - pattern: "--detach"
    - repl: ""
    - backup: False

"{{ slsdotpath }}-mullvad-add-url-to-desktop-application":
  file.replace:
    - require:
      - file: "{{ slsdotpath }}-mullvad-do-not-detach-from-desktop-application"
    - name: /usr/share/applications/qusal-mullvad-browser.desktop
    - pattern: '/start-mullvad-browser(.*)[^%u]$'
    - repl: '/start-mullvad-browser\1%u'
    - backup: False

{% endif -%}
