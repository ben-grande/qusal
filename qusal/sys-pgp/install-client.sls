{% if grains['nodename'] != 'dom0' -%}

include:
  - .install

{% endif -%}
