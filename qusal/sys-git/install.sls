{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

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

"{{ slsdotpath }}-rpc":
  file.recurse:
    - name: /etc/qubes-rpc/
    - source: salt://{{ slsdotpath }}/files/rpc/
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
