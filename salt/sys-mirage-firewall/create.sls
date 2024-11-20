{#
SPDX-FileCopyrightText: 2022 Thien Tran <contact@tommytran.io>
SPDX-FileCopyrightText: 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: MIT
#}

{%- from "qvm/template.jinja" import load -%}

{% set mirage_version = 'v0.9.2' -%}
{% set mirage_sha256sum = '78a1ee52574b9a4fc5eda265922bcbcface90f7c43ed7a68dc8e201a2ac0a7dc' %}
{% set mirage_file_kernel = 'qubes-firewall.xen' -%}
{% set mirage_url_kernel = 'https://github.com/mirage/qubes-mirage-firewall/releases/download/' ~ mirage_version ~ '/' ~ mirage_file_kernel -%}

{# Use the netvm of the default_netvm. #}
{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
{% set netvm = salt['cmd.shell']('qvm-prefs ' + default_netvm + ' netvm') -%}
{#
If netvm of default_netvm is empty, user's default_netvm is the first in
the chain (sys-net).
#}
{% if netvm == '' %}
  {% set netvm = default_netvm %}
{% endif %}

{# The 'updatevm' has networking and 'curl' present. #}
{% set updatevm = salt['cmd.shell']('qubes-prefs updatevm') %}

"sys-mirage-firewall-start-updatevm-{{ updatevm }}":
  qvm.start:
    - name: {{ updatevm }}

"sys-mirage-firewall-fetch-kernel":
  cmd.run:
    - require:
      - qvm: "sys-mirage-firewall-start-updatevm-{{ updatevm }}"
    - name: |
        qvm-run {{ updatevm }} -- "
          mkdir -p -- /tmp/mirage-firewall-download
          cd /tmp/mirage-firewall-download
          curl --location \
            --connect-timeout 10 \
            --tlsv1.3 --proto =https \
            --fail --fail-early \
            --no-progress-meter --silent --show-error \
            --remote-name {{ mirage_url_kernel }}"
    - timeout: 30

"sys-mirage-firewall-create-temporary-kernel-directory":
  file.directory:
    - require:
      - cmd: "sys-mirage-firewall-fetch-kernel"
    - name: /tmp/mirage-firewall-download
    - user: root
    - group: root
    - mode: '0700'
    - makedirs: True

"sys-mirage-firewall-bring-kernel-to-dom0":
  cmd.run:
    - require:
      - file: "sys-mirage-firewall-create-temporary-kernel-directory"
    - name: qvm-run --pass-io {{ updatevm }} -- "cat /tmp/mirage-firewall-download/qubes-firewall.xen" | tee -- /tmp/mirage-firewall-download/vmlinuz >/dev/null
    - timeout: 10

"sys-mirage-firewall-remove-kernel-from-updatevm":
  cmd.run:
    - name: qvm-run {{ updatevm }} -- "rm -rf /tmp/mirage-firewall-download"

"sys-mirage-firewall-move-kernel-to-usable-directory":
  file.managed:
    - require:
      - cmd: "sys-mirage-firewall-bring-kernel-to-dom0"
    - name: /var/lib/qubes/vm-kernels/mirage-firewall/vmlinuz
    - source: /tmp/mirage-firewall-download/vmlinuz
    - source_hash: sha256={{ mirage_sha256sum }}
    - user: root
    - group: root
    - mode: '0644'

"sys-mirage-firewall-remove-temporary-kernel":
  file.absent:
    - name: /tmp/mirage-firewall-download

"sys-mirage-firewall-save-version":
  file.managed:
    - require:
      - file: "sys-mirage-firewall-move-kernel-to-usable-directory"
    - name: /var/lib/qubes/vm-kernels/mirage-firewall/version.txt
    - contents: {{ mirage_version }}
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% load_yaml as defaults -%}
name: tpl-sys-mirage-firewall
force: True
require:
- file: sys-mirage-firewall-save-version
present:
- class: TemplateVM
- label: black
prefs:
- virt_mode: pvh
- label: black
- audiovm: ""
- memory: 64
- maxmem: 64
- vcpus: 1
- kernel: mirage-firewall
- kernelopts: ""
- include_in_backups: False
features:
- enable:
  - skip-update
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: dvm-sys-mirage-firewall
force: True
require:
- qvm: tpl-sys-mirage-firewall
present:
- template: tpl-sys-mirage-firewall
- label: orange
prefs:
- template: tpl-sys-mirage-firewall
- label: orange
- netvm: {{ netvm }}
- audiovm: ""
- memory: 64
- maxmem: 64
- vcpus: 1
- provides-network: True
- template_for_dispvms: True
- include_in_backups: False
features:
- enable:
  - service.qubes-firewall
  - no-default-kernelopts
{%- endload %}
{{ load(defaults) }}

{% load_yaml as defaults -%}
name: disp-sys-mirage-firewall
force: True
require:
- qvm: tpl-sys-mirage-firewall
present:
- class: DispVM
- template: dvm-sys-mirage-firewall
- label: orange
prefs:
- template: dvm-sys-mirage-firewall
- label: orange
- netvm: {{ netvm }}
- audiovm: ""
- memory: 64
- maxmem: 64
- vcpus: 1
- provides-network: True
- include_in_backups: False
features:
- enable:
  - service.qubes-firewall
  - no-default-kernelopts
{%- endload %}
{{ load(defaults) }}
