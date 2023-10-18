{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-common

"{{ slsdotpath }}-updated-lynx":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-lynx":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - lynx

{% endif -%}
