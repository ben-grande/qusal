{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-client-proxy

"{{ slsdotpath }}-updated-cryptsetup":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-cryptsetup":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - cryptsetup

{% endif -%}
