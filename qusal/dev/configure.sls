{% if grains['nodename'] != 'dom0' -%}

include:
  - .home-cleanup
  - dotfiles.copy-all

{% endif -%}
