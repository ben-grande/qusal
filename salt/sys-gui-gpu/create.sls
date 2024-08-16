{#
SPDX-FileCopyrightText: 2020 Artur Puzio <contact@puzio.waw.pl>
SPDX-FileCopyrightText: 2020 Frederic Pierret <frederic.pierret@qubes-os.org>
SPDX-FileCopyrightText: 2020 - 2024 Marmarek Marczykowski-Gorecki <marmarek@invisiblethingslab.com>
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-2.0-only
#}

{%- from "qvm/template.jinja" import load -%}
{%- from "qvm/template-gui.jinja" import gui_common -%}

include:
  - .clone

"{{ slsdotpath }}-gpu-installed":
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
name: tpl-{{ slsdotpath }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- audiovm: ""
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: {{ slsdotpath }}-gpu
force: True
require:
- sls: {{ slsdotpath }}.clone
present:
- template: tpl-{{ slsdotpath }}
- label: black
prefs:
- template: tpl-{{ slsdotpath }}
- label: black
- memory: 600
- maxmem: 4000
- virt_mode: hvm
- netvm: ""
- guivm: ""
- audiovm: ""
- kernelopts: "nopat iommu=soft swiotlb=8192 root=/dev/mapper/dmroot ro console=hvc0 xen_scrub_pages=0"
- autostart: False # TODO: set to True
- include_in_backups: True
features:
- enable:
  - no-default-kernelopts
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
"{{ slsdotpath }}-gpu-input-proxy-target":
  file.managed:
    - name: /etc/qubes/input-proxy-target
    - contents: "TARGET_DOMAIN=sys-gui-gpu"

# Set Qubes RPC policy for sys-usb to sys-gui-gpu
"{{ slsdotpath }}-gpu-usb-input-proxy-target":
  file.managed:
    - name: /etc/qubes/policy.d/45-sys-gui-gpu.policy
    {% if salt['pillar.get']('qvm:sys-usb:mouse-action', 'ask') == 'ask' %}
    - text: qubes.InputMouse * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 ask user=root default_target=sys-gui-gpu
    {% elif salt['pillar.get']('qvm:sys-usb:mouse-action', 'ask') == 'allow' %}
    - text: qubes.InputMouse * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 allow user=root target=sys-gui-gpu
    {% endif %}
