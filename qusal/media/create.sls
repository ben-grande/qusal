{%- import "templates/debian-minimal.jinja" as template -%}

include:
  - .clone

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - present:
      - template: {{ template.template }}
      - label: purple
    - prefs:
      - template: {{ template.template }}
      - label: purple
      - netvm: ""
      - vcpus: 2
      - memory: 300
      - maxmem: 800
      - autostart: False
      - include_in_backups: True
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy

"dvm-{{ slsdotpath }}":
  qvm.vm:
    - name: dvm-{{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: purple
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: purple
      - netvm: ""
      - memory: 300
      - maxmem: 800
      - vcpus: 2
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy

"disp-{{ slsdotpath }}":
  qvm.vm:
    - name: disp-{{ slsdotpath }}
    - present:
      - template: dvm-{{ slsdotpath }}
      - label: purple
      - class: DispVM
    - prefs:
      - template: dvm-{{ slsdotpath }}
      - label: purple
      - vcpus: 2
      - netvm: ""
      - memory: 300
      - maxmem: 800
      - autostart: False
      - include_in_backups: False
    - features:
      - appemenus-dispvm: True
      - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy
      - enable:
        - service.shutdownle

"{{ slsdotpath }}-extend-private-volume":
  cmd.run:
    - name: qvm-volume extend {{ slsdotpath }}:private 50Gi

{% from 'utils/macros/policy.sls' import policy_set with context -%}
{{ policy_set(sls_path, '80') }}
