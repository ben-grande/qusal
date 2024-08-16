{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - .install
  - sys-usb.install-client-proxy

"{{ slsdotpath }}-bluetooth-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - blueman
      - libspa-0.2-bluetooth
      - firmware-iwlwifi

"{{ slsdotpath }}-user-systemd":
  file.recurse:
    - name: /usr/lib/systemd/user/
    - source: salt://{{ slsdotpath }}/files/server/systemd-user/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
