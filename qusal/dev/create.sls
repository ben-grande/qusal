include:
  - .clone

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: blue
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: blue
      - netvm: ""
      - vpus: 1
      - memory: 400
      - maxmem: 600
      - autostart: False
      - include_in_backups: True
    - features:
      - enable:
        - service.split-gpg2-client
        - service.crond
      - disable:
        - service.cups
        - service.cups-browsed

"dvm-{{ slsdotpath }}":
  qvm.vm:
    - name: dvm-{{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: red
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: red
      - netvm: ""
      - vpus: 1
      - memory: 400
      - maxmem: 600
      - autostart: False
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - appmenus-dispvm
      - disable:
        - service.cups
        - service.cups-browsed

"disp-{{ slsdotpath }}":
  qvm.vm:
    - name: disp-{{ slsdotpath }}
    - require:
      - qvm: dvm-{{ slsdotpath }}
    - present:
      - template: dvm-{{ slsdotpath }}
      - label: red
      - class: DispVM
    - prefs:
      - template: dvm-{{ slsdotpath }}
      - label: red
      - vpus: 1
      - memory: 400
      - maxmem: 600
      - autostart: False
      - include_in_backups: False
    - features:
      - disable:
        - appmenus-dispvm
        - service.cups
        - service.cups-browsed
