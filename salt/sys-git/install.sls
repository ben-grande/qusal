{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

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

"{{ slsdotpath }}-rpc":
  file.recurse:
    - name: /etc/qubes-rpc/
    - source: salt://{{ slsdotpath }}/files/server/rpc
    - user: root
    - group: root
    - file_mode: '0755'
    - dir_mode: '0755'
    - keep_symlinks: True
    - force_symlinks: True

"{{ slsdotpath }}-skel-repository-directory":
  file.directory:
    - name: /etc/skel/src
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

{% endif -%}
