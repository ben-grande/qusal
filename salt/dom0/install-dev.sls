{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

include:
  - sys-git.install-client

"{{ slsdotpath }}-dev-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-dev-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - vim
      - tmux
      - xclip
      - bash-completion
      - man-db
      - tree

"{{ slsdotpath }}-dev-pci-script":
  file.managed:
    - name: /usr/local/bin/qvm-pci-regain
    - source: salt://{{ slsdotpath }}/files/bin/qvm-pci-regain
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
