include:
  - .clone

"tpl-{{ slsdotpath }}":
  qvm.vm:
    - require:
      - sls: {{ slsdotpath }}.clone
    - name: tpl-{{ slsdotpath }}
    - prefs:
      - memory: 300
      - maxmem: 2000
    - features:
      - set:
        - default-menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop"
        - menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop"

"dvm-{{ slsdotpath }}":
  qvm.vm:
    - require:
      - qvm: tpl-{{ slsdotpath }}
    - name: dvm-{{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: red
    - prefs:
      - memory: 300
      - maxmem: 2000
      - vcpus: 1
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - appmenus-dispvm
      - set:
        - menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop"
