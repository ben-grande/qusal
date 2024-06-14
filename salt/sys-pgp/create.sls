{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

include:
  - .clone
  - fedora-minimal.prefs

{% load_yaml as defaults -%}
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
- sls: fedora-minimal.prefs
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: gray
prefs:
- template: tpl-{{ slsdotpath }}
- netvm: ""
- audiovm: ""
- vcpus: 1
- memory: 200
- maxmem: 300
features:
- enable:
  - servicevm
- disable:
  - service.cups
  - service.cups-browsed
{%- endload %}
{{ load(defaults) }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}

"{{ slsdotpath }}-set-management_dispvm-to-dvm-fedora":
  qvm.vm:
    - require:
      - qvm: dvm-fedora
    - name: tpl-{{ slsdotpath }}
    - prefs:
      - management_dispvm: dvm-fedora

## TODO: Remove when template with patch reaches upstream or updates enforce
## salt-deps to be installed.
## https://github.com/QubesOS/qubes-issues/issues/8806
"{{ slsdotpath }}-install-salt-deps":
  cmd.script:
    - require:
      - qvm: "{{ slsdotpath }}-set-management_dispvm-to-dvm-fedora"
    - name: salt-patch.sh
    - source: salt://fedora-minimal/files/admin/bin/salt-patch.sh
    - args: tpl-{{ slsdotpath }}
