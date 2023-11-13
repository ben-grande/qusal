{#
SPDX-FileCopyrightText: 2023 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

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

"sys-mirage-firewall-create-vm-kernels-dir":
  file.directory:
    - name: /var/lib/qubes/vm-kernels/mirage-firewall
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"sys-mirage-firewall-extract-to-vm-kernels":
  archive.extracted:
    - name: /var/lib/qubes/vm-kernels/
    - require:
      - file: sys-mirage-firewall-create-vm-kernels-dir
    - source: salt://sys-mirage-firewall/files/admin/mirage-firewall.tar.bz2
    - source_hash: salt://sys-mirage-firewall/files/admin/mirage-firewall.sha256
    - archive_format: tar
    - options: -j

"sys-mirage-firewall-save-version":
  file.managed:
    - name: /var/lib/qubes/vm-kernels/mirage-firewall/version.txt
    - source: salt://sys-mirage-firewall/files/admin/version.txt
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% load_yaml as defaults -%}
name: sys-mirage-firewall
force: True
require:
  - file: sys-mirage-firewall-save-version
present:
- class: StandaloneVM
- label: orange
- virt_mode: pvh
prefs:
- label: orange
- netvm: {{ netvm }}
- memory: 64
- maxmem: 64
- vcpus: 1
- provides-network: True
- default_dispvm: ""
- kernel: mirage-firewall
- kernelopts: ''
features:
- enable:
  - service.qubes-firewall
  - no-default-kernelopts
{%- endload %}
{{ load(defaults) }}
