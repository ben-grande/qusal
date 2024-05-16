{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{% if grains['os_family']|lower == 'debian' -%}
include:
  - .install-repo
  - utils.tools.common.update
{% endif -%}

"{{ slsdotpath }}-installed":
  pkg.installed:
    {% if grains['os_family']|lower == 'debian' -%}
    - require:
      - sls: {{ slsdotpath }}.install-repo
      - sls: utils.tools.common.update
    {% endif %}
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - socat
      - syncthing

{% set pkg = {
    'Debian': {
      'pkg': ['libpam-systemd'],
    },
    'RedHat': {
      'pkg': ['systemd-pam'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-set-systemd-qubes-syncthing-forwarder.service":
  file.managed:
    - name: /usr/lib/systemd/system/qubes-syncthing-forwarder.service
    - source: salt://{{ slsdotpath }}/files/client/systemd/qubes-syncthing-forwarder.service
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

"{{ slsdotpath }}-enable-qubes-syncthing":
  service.enabled:
    - name: qubes-syncthing.service

{% endif -%}
