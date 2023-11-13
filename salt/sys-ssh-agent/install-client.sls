{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - ssh.install
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-ssh
  - dotfiles.copy-x11

"{{ slsdotpath }}-client-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-client-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - socat

{% set pkg = {
    'Debian': {
      'pkg': ['procps'],
    },
    'RedHat': {
      'pkg': ['procps-ng'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-client-installed-os-specific":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-client-system-systemd-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/client/systemd/
    - name: /usr/lib/systemd/system/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root

{% endif %}
