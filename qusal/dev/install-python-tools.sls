{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-updated-network":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed-network":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - python3-dev
      - python3-venv
      - python3-setuptools
      - python3-pytest
      - python3-pip

{% endif %}
