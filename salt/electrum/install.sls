{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-x11

"{{ slsdotpath }}-remove-distro-package":
  pkg.removed:
    - setopt: "install_weak_deps=False"
    - pkgs:
      - electrum
      - python3-electrum

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
      - pkg: "{{ slsdotpath }}-remove-distro-package"
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - socat
      - man-db
      ## Recommends
      - python3-zbar
      ## Unlisted dependency.
      - python3-jsonpatch
      ## Dependencies retrieved from 'electrum' and 'python3-electrum' pkg.
      - python3-pyqt5
      - libjs-jquery
      - libjs-jquery-ui
      - libjs-jquery-ui-theme-ui-lightness
      - libsecp256k1-1
      - node-qrcode-generator
      - python3-cryptography
      - python3-distutils
      - python3-aiohttp
      - python3-aiohttp-socks
      - python3-aiorpcx
      - python3-attr
      - python3-bitstring
      - python3-certifi
      - python3-dnspython
      - python3-protobuf
      - python3-qrcode

"{{ slsdotpath }}-rpc":
  file.recurse:
    - name: /etc/qubes-rpc/
    - source: salt://{{ slsdotpath }}/files/client/rpc/
    - user: root
    - group: root
    - file_mode: '0755'
    - dir_mode: '0755'
    - makedirs: True

{% endif -%}
