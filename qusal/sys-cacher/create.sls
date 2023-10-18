include:
  - .clone

"{{ slsdotpath }}":
  qvm.vm:
    - require:
      - sls: {{ slsdotpath }}.clone
    - name: {{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: gray
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: gray
      - memory: 300
      - maxmem: 600
      - vcpus: 1
      - provides-network: true
    - features:
      - enable:
        - servicevm
        - service.shutdown-idle
      - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '75') }}

"{{ slsdotpath }}-extend-volume":
  cmd.run:
    - name: qvm-volume extend {{ slsdotpath }}:private 20Gi
    - require:
      - qvm: {{ slsdotpath }}
