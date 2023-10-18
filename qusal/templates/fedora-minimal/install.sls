{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

{% endif %}
