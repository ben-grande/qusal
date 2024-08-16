{#
SPDX-FileCopyrightText: 2019 - 2020 Frederic Pierret <frederic.pierret@qubes-os.org>
SPDX-FileCopyrightText: 2020 - 2024 Marmarek Marczykowski-Gorecki <marmarek@invisiblethingslab.com>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-2.0-only
#}

{%- from "qvm/template.jinja" import load -%}
{%- from "qvm/template-gui.jinja" import gui_common -%}

include:
  - .clone

{% if 'psu' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) or 'backlight' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
"{{ slsdotpath }}-installed":
  pkg.installed:
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      {% if 'psu' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
      - dummy-psu-sender
      {% endif %}
      {% if 'backlight' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
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
name: {{ slsdotpath }}
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
- memory: 400
- maxmem: 4000
- guivm: dom0
- audiovm: dom0
- autostart: False # TODO: set to True
- include_in_backups: True
features:
- enable:
  - gui-allow-fullscreen
  - service.guivm
  - service.guivm-gui-agent
  {% if 'psu' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
  - service.dummy-psu
  {% endif %}
  {% if 'backlight' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
  - service.dummy-backlight
  {% endif %}
- set:
  - gui-secure-copy-sequence: none
  - gui-secure-paste-sequence: none
{%- endload %}
{{ load(defaults) }}

{{ gui_common(defaults.name) }}

"{{ slsdotpath }}-xsessions":
  file.managed:
    - name: /usr/share/xsessions/sys-gui.desktop
    - source: salt://{{ slsdotpath }}/files/server/xsessions/sys-gui.desktop
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True
