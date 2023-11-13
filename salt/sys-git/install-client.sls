{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - dotfiles.copy-git
  - dotfiles.copy-sh
  - dotfiles.copy-x11
  - sys-pgp.install-client

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - git

{% set git = {
    'Debian': {
      'exec_path': '/usr/lib/git-core',
    },
    'RedHat': {
      'exec_path': '/usr/libexec/git-core',
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-install-client-git-core-dir":
  file.recurse:
    - require:
      - pkg: {{ slsdotpath }}-installed
    - source: salt://{{ slsdotpath }}/files/client/git-core
    - name: {{ git.exec_path }}
    - file_mode: '0755'
    - dir_mode: '0755'
    - user: root
    - group: root
    - makedirs: True
    - recurse:
      - mode
      - user
      - group
