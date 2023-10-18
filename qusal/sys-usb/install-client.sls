{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-client-cryptsetup
  - .install-client-fido

{% endif -%}
