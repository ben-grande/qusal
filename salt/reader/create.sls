{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
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
  - default-menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
  - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"
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
- template: tpl-{{ slsdotpath }}
- label: red
- netvm: ""
- audiovm: ""
- memory: 400
- maxmem: 700
- vcpus: 1
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
- set:
  # editorconfig-checker-disable
  - default-menu-items: "qusal-mullvad-browser.desktop org.mozilla.firefox.desktop firefox.desktop firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop libreoffice-base.desktop libreoffice-calc.desktop libreoffice-draw.desktop libreoffice-impress.desktop libreoffice-math.desktop libreoffice-startcenter.desktop libreoffice-writer.desktop org.gnome.Evince.desktop qubes-open-file-manager.desktop" # noqa: 204
  - menu-items: "qusal-mullvad-browser.desktop org.mozilla.firefox.desktop firefox.desktop firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop libreoffice-base.desktop libreoffice-calc.desktop libreoffice-draw.desktop libreoffice-impress.desktop libreoffice-math.desktop libreoffice-startcenter.desktop libreoffice-writer.desktop org.gnome.Evince.desktop qubes-open-file-manager.desktop" # noqa: 204
  # editorconfig-checker-enable
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-set-default_dispvm":
  cmd.run:
    - name: qubes-prefs default_dispvm dvm-{{ slsdotpath }}
    - require:
      - qvm: dvm-{{ slsdotpath }}
