{#
SPDX-FileCopyrightText: 2020 Artur Puzio <contact@puzio.waw.pl>
SPDX-FileCopyrightText: 2020 Frederic Pierret <frederic.pierret@qubes-os.org>
SPDX-FileCopyrightText: 2020 - 2025 Marmarek Marczykowski-Gorecki <marmarek@invisiblethingslab.com>
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-2.0-only
#}

{%- from "qvm/template.jinja" import load -%}
{%- from "qvm/template-gui.jinja" import gui_common -%}

include:
  - {{ slsdotpath }}.clone
  - sys-gui.create

"{{ slsdotpath }}-installed":
  pkg.installed:
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-input-proxy-sender
      {% if 'psu' in salt['pillar.get']('qvm:sys-gui-gpu:dummy-modules', []) %}
      - dummy-psu-sender
      {% endif %}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}
force: True
require:
- qvm: tpl-sys-gui
present:
- template: tpl-sys-gui
- label: black
prefs:
- template: tpl-sys-gui
- label: black
- memory: 600
- maxmem: 4000
- virt_mode: hvm
- netvm: ""
- guivm: ""
- audiovm: ""
- autostart: False # TODO: set to True
- include_in_backups: True
features:
- enable:
  - service.lightdm
  - service.guivm
  {% if 'psu' in salt['pillar.get']('qvm:sys-gui-gpu:dummy-modules', []) %}
  - service.dummy-psu
  {% endif %}
- set:
  - video-model: none
  - input-dom0-proxy: true
{%- endload %}
{{ load(defaults) }}

{{ gui_common(defaults.name) }}

# Set GuiVM target for input-proxy-sender of dom0 attached input devices (not USB)
"{{ slsdotpath }}-input-proxy-target":
  file.managed:
    - name: /etc/qubes/input-proxy-target
    - contents: "TARGET_DOMAIN=sys-gui-gpu"

{% if salt['pillar.get']('qvm:sys-usb:mouse-action', 'ask') == 'ask' %}
{% set mouse_action = 'ask user=root default_target=sys-gui-gpu' %}
{% elif salt['pillar.get']('qvm:sys-usb:mouse-action', 'ask') == 'allow' %}
{% set mouse_action = 'allow user=root target=sys-gui-gpu' %}
{% else %}
{% set mouse_action = 'deny' %}
{% endif %}

{% if salt['pillar.get']('qvm:sys-usb:keyboard-action', 'deny') == 'ask' %}
{% set keyboard_action = 'ask user=root default_target=sys-gui-gpu' %}
{% elif salt['pillar.get']('qvm:sys-usb:keyboard-action', 'deny') == 'allow' %}
{% set keyboard_action = 'allow user=root target=sys-gui-gpu' %}
{% else %}
{% set keyboard_action = 'deny' %}
{% endif %}

# Setup Qubes RPC policy for sys-usb to sys-gui-gpu
"{{ slsdotpath }}-input-proxy":
  file.managed:
    - name: /etc/qubes/policy.d/45-sys-gui-gpu.policy
    - contents: |
        qubes.InputMouse * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 {{ mouse_action }}
        qubes.InputKeyboard * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 {{ keyboard_action }}
        # not configurable by this state
        qubes.InputTablet * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 deny
