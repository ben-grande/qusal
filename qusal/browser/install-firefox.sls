{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-common

"{{ slsdotpath }}-updated-firefox":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-firefox":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - firefox-esr

{% endif -%}
