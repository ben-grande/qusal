{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - keepassxc
      - gnupg2
      {% if grains['os_family']|lower == 'debian' -%}
      - sq
      {% elif grains['os_family']|lower == 'debian' -%}
      - sequoia-sq
      {% endif -%}
      - openssh-client

{% endif -%}
