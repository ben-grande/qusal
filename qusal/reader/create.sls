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
        - default-menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop libreoffice-base.desktop libreoffice-calc.desktop libreoffice-draw.desktop libreoffice-impress.desktop libreoffice-math.desktop libreoffice-startcenter.desktop libreoffice-writer.desktop org.gnome.Evince.desktop qubes-open-file-manager.desktop"
        - menu-items: "firefox-esr.desktop chromium.desktop google-chrome.desktop qubes-run-terminal.desktop qubes-start.desktop libreoffice-base.desktop libreoffice-calc.desktop libreoffice-draw.desktop libreoffice-impress.desktop libreoffice-math.desktop libreoffice-startcenter.desktop libreoffice-writer.desktop org.gnome.Evince.desktop qubes-open-file-manager.desktop"

"dvm-{{ slsdotpath }}":
  qvm.vm:
    - name: dvm-{{ slsdotpath }}
    - require:
      - qvm: tpl-{{ slsdotpath }}
    - present:
      - template: tpl-{{ slsdotpath }}
      - label: red
    - prefs:
      - template: tpl-{{ slsdotpath }}
      - label: red
      - netvm: ""
      - memory: 400
      - maxmem: 700
      - vcpus: 1
      - template_for_dispvms: True
      - include_in_backups: False
    - features:
      - enable:
        - appmenus-dispvm
      - set:
        - menu-items: "qubes-run-terminal.desktop qubes-start.desktop"

"{{ slsdotpath }}-set-default_dispvm":
  cmd.run:
    - name: qubes-prefs default_dispvm dvm-{{ slsdotpath }}
    - require:
      - qvm: dvm-{{ slsdotpath }}
