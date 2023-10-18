{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-common

"{{ slsdotpath }}-updated-chromium":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-chromium":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - chromium

{% endif -%}
