{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - pciutils
      - qubes-input-proxy-sender
      - qubes-usb-proxy
      - qubes-u2f
      #- qubes-ctap

{% endif -%}
