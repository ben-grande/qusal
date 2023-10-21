{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: Vim
#}

{%- import "path/to/file.jinja" as tpl -%}

include:
  - test.file

this-is-not-include:
  - name: include should not be highlighted

test-{{ tpl }}-test:
  module.here:
    - name: the jinja variable in the directive does not allow the rest of the key to be highlighted

directive here:
  module.here:
    - require:
      - sls: test.file
    - name: tpl-test
    - prefs:
      - netvm: ""
      - vpus: 1
      - memory: 400
      - autostart: False
