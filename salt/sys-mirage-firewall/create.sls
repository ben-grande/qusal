{#
SPDX-FileCopyrightText: 2022 Thien Tran <contact@tommytran.io>
SPDX-FileCopyrightText: 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: MIT
#}

{%- from "qvm/template.jinja" import load -%}

{% set mirage_version = 'v0.9.1' -%}
{% set mirage_file_archive = 'mirage-firewall.tar.bz2' -%}
{% set mirage_url_archive = 'https://github.com/mirage/qubes-mirage-firewall/releases/download/' ~ mirage_version ~ '/' ~ mirage_file_archive -%}
{% set mirage_sha256sum = 'ea876bc7525811a16b0dfebe7ee1e91661eeecf67d240298d4ffd31b6ee41843' %}

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

"sys-mirage-firewall-fetch-tarball":
  cmd.run:
    - require:
      - qvm: "sys-mirage-firewall-start-updatevm-{{ updatevm }}"
    - name: |
        qvm-run {{ updatevm }} -- "
          mkdir -p /tmp/mirage-firewall-download
          cd /tmp/mirage-firewall-download
          curl --location \
            --connect-timeout 10 \
            --tlsv1.3 --proto =https \
            --fail --fail-early \
            --no-progress-meter --silent --show-error \
            --remote-name {{ mirage_url_archive }}"
    - timeout: 30
    - runas: user

{# Tarball is brought to dom0 instead of just 'vmlinuz' because:
  - checksum on releases is only of the tarball, not of individual files;
  - updatevm may not have 'bzip2' and 'tar';
  - if we don't trust the provided tarball, we shouldn't even download it.
#}
"sys-mirage-firewall-bring-tarball-to-dom0":
  cmd.run:
    - require:
      - cmd: "sys-mirage-firewall-fetch-tarball"
    - name:
        qvm-run --pass-io {{ updatevm }} -- "cat /tmp/mirage-firewall-download/mirage-firewall.tar.bz2" | tee /tmp/mirage-firewall.tar.bz2 >/dev/null
    - runas: user
    - timeout: 10

"{{ slsdotpath }}-remove-tarball-from-updatevm":
  cmd.run:
    - name: qvm-run {{ updatevm }} -- "rm -rf /tmp/mirage-firewall-download"

"sys-mirage-firewall-extract-to-vm-kernels":
  archive.extracted:
    - require:
      - cmd: "sys-mirage-firewall-bring-tarball-to-dom0"
    - name: /var/lib/qubes/vm-kernels/
    - source: /tmp/mirage-firewall.tar.bz2
    - source_hash: sha256={{ mirage_sha256sum }}
    - archive_format: tar
    - options: -j

"{{ slsdotpath }}-dom0-archive":
  file.absent:
    - name: /tmp/mirage-firewall.tar.bz2

"sys-mirage-firewall-save-version":
  file.managed:
    - require:
      - archive: "sys-mirage-firewall-extract-to-vm-kernels"
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
