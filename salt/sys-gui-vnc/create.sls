{#
SPDX-FileCopyrightText: 2021 Frederic Pierret <frederic.pierret@qubes-os.org>
SPDX-FileCopyrightText: 2021 - 2024 Marmarek Marczykowski-Gorecki <marmarek@invisiblethingslab.com>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-2.0-only
#}

{%- from "qvm/template.jinja" import load -%}
{%- from "qvm/template-gui.jinja" import gui_common -%}

include:
  - .clone

{% if 'psu' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) or 'backlight' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
"{{ slsdotpath }}-vnc-installed":
  pkg.installed:
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      {% if 'psu' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
      - dummy-psu-sender
      {% endif %}
      {% if 'backlight' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
      - dummy-backlight-dom0
      {% endif %}
{% endif %}

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
name: {{ slsdotpath }}-vnc
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: black
prefs:
- template: tpl-{{ slsdotpath }}
- label: black
- memory: 400
- maxmem: 4000
- netvm: ""
- guivm: dom0
- audiovm: ""
- autostart: False # TODO: set to True
- include_in_backups: True
features:
- enable:
  - service.lightdm
  - service.guivm
  - service.guivm-vnc
  {% if 'psu' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
  - service.dummy-psu
  {% endif %}
  {% if 'backlight' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
  - service.dummy-backlight
  {% endif %}
{%- endload %}
{{ load(defaults) }}

{{ gui_common(defaults.name) }}
