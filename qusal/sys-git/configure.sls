{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-git

{% endif -%}
