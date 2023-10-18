include:
  - .clone

{% set net_pcidevs = salt['grains.get']('pci_net_devs', []) -%}

"{{ slsdotpath }}":
  qvm.vm:
    - name: {{ slsdotpath }}
    - require:
      - sls: {{ slsdotpath }}.clone
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: red
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: red
      - netvm: ""
      - memory: 0
      - maxmem: 400
      - vcpus: 1
      - virt_mode: hvm
      - autostart: False
      - provides-network: True
      # - pcidevs: [ '03:00.0', '00:19.0' ]
      - pcidevs: {{ net_pcidevs|yaml }}
      - pci_strictreset: False
      - include_in_backups: False
    - features:
      - enable:
        - servicevm
        - service.qubes-updates-proxy
        - service.clocksync
      - disable:
        - service.cups
        - service.cups-browsed
        - service.meminfo-writer

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
      - memory: 0
      - maxmem: 400
      - vcpus: 1
      - virt_mode: hvm
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - servicevm
        - service.qubes-updates-proxy
        - service.clocksync
      - disable:
        - appmenus-dispvm
        - service.cups
        - service.cups-browsed
        - service.meminfo-writer

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
      - netvm: ""
      - autostart: False
      - provides-network: True
      # - pcidevs: [ '03:00.0', '00:19.0' ]
      - pcidevs: {{ net_pcidevs|yaml }}
      - pci_strictreset: False
      - include_in_backups: False
    - features:
      - enable:
        - servicevm
        - service.qubes-updates-proxy
        - service.clocksync
      - disable:
        - appmenus-dispvm
        - service.cups
        - service.cups-browsed
        - service.meminfo-writer
