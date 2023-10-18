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
      - vcpus: 1
      - memory: 200
      - maxmem: 300
    - features:
      - enable:
        - servicevm
      - disable:
        - service.cups
        - service.cups-browsed

"{{ slsdotpath }}-resize-private-volume":
  cmd.run:
    - name: qvm-volume resize {{ slsdotpath }}:private 20Gi
    - require:
      - qvm: {{ slsdotpath }}

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
