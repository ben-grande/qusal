{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{%- import "debian/template.jinja" as template -%}

## TODO: Loop as currently it doesn't check recursively
## Use the netvm of the default_netvm.
{% set default_netvm = salt['cmd.shell']('qubes-prefs default_netvm') -%}
{% set netvm = salt['cmd.shell']('qvm-prefs ' + default_netvm + ' netvm') -%}
## If netvm is empty, user's default_netvm is the uplink (sys-net).
{% if netvm == '' %}
  {% set netvm = default_netvm %}
{% endif %}

include:
  - .clone

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: {{ template.template }}
      - label: orange
      - class: StandaloneVM
    - prefs:
      - label: orange
      - memory: 300
      - maxmem: 800
      - vcpus: 1
      - netvm: {{ netvm }}
      - provides-network: true
    - features:
      - enable:
        - servicevm
        - service.updates-proxy-setup
      - disable:
        - service.cups
        - service.cups-browsed

"{{ slsdotpath }}-resize-private-volume":
  cmd.run:
    - name: qvm-volume resize {{ slsdotpath }}:private 20Gi
    - require:
      - qvm: {{ slsdotpath }}
