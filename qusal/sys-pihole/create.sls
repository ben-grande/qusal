{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{%- import "debian/template.jinja" as template -%}

## Use the netvm of the default_netvm.
{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
{% set netvm = salt['cmd.shell']('qvm-prefs ' + default_netvm + ' netvm') -%}
## If netvm of default_netvm is empty, user's default_netvm is the first in
## the chain (sys-net).
{% if netvm == '' %}
  {% set netvm = default_netvm %}
{% endif %}

include:
  - .clone
  - browser.create

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: {{ template.template }}
- label: orange
- class: StandaloneVM
prefs:
- label: orange
- memory: 300
- maxmem: 800
- vcpus: 1
- netvm: {{ netvm }}
- provides-network: true
features:
- enable:
  - servicevm
  - service.updates-proxy-setup
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-browser-{{ slsdotpath }}
force: True
require:
- sls: browser.create
present:
- template: tpl-browser
- label: orange
prefs:
- label: orange
- memory: 300
- maxmem: 800
- vcpus: 1
- netvm: ""
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
- set:
  - menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop"
{%- endload %}
{{ load(defaults) }}


{% load_yaml as defaults -%}
name: disp-browser-{{ slsdotpath }}
force: True
require:
- sls: browser.create
present:
- template: dvm-browser-{{ slsdotpath }}
- label: orange
- class: DispVM
prefs:
- label: orange
- memory: 300
- maxmem: 800
- vcpus: 1
- netvm: ""
features:
- disable:
  - service.cups
  - service.cups-browsed
- set:
  - menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-open-file-manager.desktop qubes-run-terminal.desktop"
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-resize-private-volume":
  cmd.run:
    - name: qvm-volume resize {{ slsdotpath }}:private 20Gi
    - require:
      - qvm: {{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_unset(sls_path, '80') }}
