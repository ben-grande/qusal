{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - utils.tools.common.update
  - dotfiles.copy-git
  - dotfiles.copy-sh
  - dotfiles.copy-x11
  - sys-pgp.install-client

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - git
      - man-db

{% set git = {
    'Debian': {
      'exec_path': '/usr/lib/git-core',
    },
    'RedHat': {
      'exec_path': '/usr/libexec/git-core',
    },
    'Qubes OS': {
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

{% if not salt['file.file_exists']('/usr/share/whonix/marker') -%}
{#
  Whonix's security-misc package owns /etc/gitconfig, fallback to Git dotfiles
  to set this option.
#}

"{{ slsdotpath }}-install-client-allow-protocol":
  cmd.run:
    - name: git config --system protocol.qrexec.allow always
    - runas: root

{% endif -%}
