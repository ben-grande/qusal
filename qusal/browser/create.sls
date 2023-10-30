{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

include:
  - .clone

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- memory: 300
- maxmem: 2000
features:
- set:
  - default-menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop"
  - menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}
force: True
require:
- qvm: tpl-{{ slsdotpath }}
present:
- template: tpl-{{ slsdotpath }}
- label: red
prefs:
- label: red
- memory: 300
- maxmem: 2000
- vcpus: 1
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
- set:
  - menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop"
{%- endload %}
{{ load(defaults) }}
