include:
  - .clone

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: blue
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: blue
      - vpus: 1
      - memory: 400
      - maxmem: 600
      - autostart: False
    - features:
      - disable:
        - service.cups
        - service.cups-browsed
        - service.tinyproxy
