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
      - qubes-core-agent-networking
      - ca-certificates
      - remmina
      - remmina-plugin-rdp
      - remmina-plugin-vnc
      - remmina-plugin-www
      - remmina-plugin-x2go

{% endif -%}
