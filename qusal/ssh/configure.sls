{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-ssh

{% endif -%}
