include:
  - .clone

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: gray
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: gray
      - netvm: ""
      - memory: 200
      - maxmem: 300
      - vcpus: 1
    - features:
      - enable:
        - servicevm
      - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
