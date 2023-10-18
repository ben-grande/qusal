{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11
  - dotfiles.copy-ssh
  - sys-ssh-agent.install-client

{% endif -%}
