{% if grains['nodename'] != 'dom0' -%}

include:
  - .touch-zshrc

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - zsh
      - zsh-autosuggestions
      - zsh-syntax-highlighting

{% endif -%}
