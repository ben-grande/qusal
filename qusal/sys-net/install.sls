{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-debug
  - dotfiles.copy-x11

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-network-manager
      - wpasupplicant
      - gnome-keyring

{% endif -%}
