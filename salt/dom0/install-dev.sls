{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

include:
  - utils.tools.common.update
  - sys-git.install-client

"{{ slsdotpath }}-dev-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
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
