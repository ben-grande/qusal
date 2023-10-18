{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-common
  - dotfiles.copy-net

"{{ slsdotpath }}-updated-w3m":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-w3m":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - w3m

{% endif -%}
