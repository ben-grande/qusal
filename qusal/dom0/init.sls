{% if grains['nodename'] == 'dom0' -%}

include:
  - .install
  - .backup
  - .xorg
  - .kde
  - .dotfiles

{% endif -%}
