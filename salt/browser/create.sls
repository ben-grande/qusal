{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - .clone

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
- memory: 300
- maxmem: 2000
features:
- set:
  # editorconfig-checker-disable
  - default-menu-items: "qusal-mullvad-browser.desktop org.mozilla.firefox.desktop firefox.desktop firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop" # noqa: 204
  - menu-items: "qusal-mullvad-browser.desktop org.mozilla.firefox.desktop firefox.desktop firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop" # noqa: 204
  # editorconfig-checker-enable
- disable:
  - service.tracker
  - service.evolution-data-server
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
- audiovm: "*default*"
- memory: 300
- maxmem: 2000
- vcpus: 1
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
  - service.qubes-ctap-proxy
- disable:
  - service.tracker
  - service.evolution-data-server
- set:
  # editorconfig-checker-disable
  - menu-items: "qusal-mullvad-browser.desktop org.mozilla.firefox.desktop firefox.desktop firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-open-file-manager.desktop qubes-start.desktop" # noqa: 204
  # editorconfig-checker-enable
{%- endload %}
{{ load(defaults) }}
