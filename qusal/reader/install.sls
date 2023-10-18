{% if grains['nodename'] != 'dom0' -%}

include:
  - browser.install

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - libreoffice
      - antiword
      - evince
      - python3-pdfminer
      - vim

{% endif -%}
