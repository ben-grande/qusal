{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - fedora.create
  - .clone

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: black
prefs:
- template: tpl-{{ slsdotpath }}
- label: black
- netvm: ""
- audiovm: ""
- dispvm-allowed: True
- vcpus: 1
- memory: 300
- maxmem: 600
- autostart: False
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - appmenus-dispvm
  - internal
{%- endload %}
{{ load(defaults) }}

"{{ slsdotpath }}-set-management_dispvm-to-dvm-fedora":
  cmd.run:
    - require:
      - qvm: dvm-fedora
    - name: qubes-prefs management_dispvm dvm-fedora

## TODO: Remove when template with patch reaches upstream.
## https://github.com/QubesOS/qubes-issues/issues/8806
"{{ slsdotpath }}-install-":
  cmd.run:
    - require:
      - qvm: tpl-{{ slsdotpath }}
    - name: qvm-run -u root tpl-{{ slsdotpath }} -- dnf install --refresh --assumeyes --setopt=install_weak_deps=False python3-urllib3
