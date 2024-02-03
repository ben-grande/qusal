{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- from "qvm/template.jinja" import load -%}

{%- import slsdotpath ~ "/template.jinja" as template -%}

include:
  - .clone

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - grub2-xen-pvh

{% load_yaml as defaults -%}
name: {{ template.template }}
force: True
require:
- sls: {{ slsdotpath }}.clone
prefs:
- virt_mode: pv
- kernel: pvgrub2-pvh
{%- endload %}
{{ load(defaults) }}
