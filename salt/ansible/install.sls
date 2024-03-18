{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-repo
  - utils.tools.common.update
  - utils.tools.zsh
  - ssh.install

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install-repo
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - ansible
      - ansible-lint
      - python3-argcomplete
      - python3-jmespath
      - openssh-server
      - qubes-core-agent-passwordless-root
      - bash-completion
      - man-db

{% set pkg = {
    'Debian': {
      'pkg': ['vim-nox', 'python3-selinux'],
    },
    'RedHat': {
      'pkg': ['vim-enhanced', 'vim-ansible'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-ssh-config":
  file.managed:
    - name: /etc/ssh/ssh_config.d/99-ssh-ansible.conf
    - source: salt://{{ slsdotpath }}/files/server/99-ssh-ansible.conf
    - mode: '0644'
    - user: root
    - group: root

"{{ slsdotpath }}-sshd-config":
  file.managed:
    - name: /etc/ssh/sshd_config.d/99-sshd-ansible.conf
    - source: salt://{{ slsdotpath }}/files/client/99-sshd-ansible.conf
    - mode: '0644'
    - user: root
    - group: root

{% endif -%}
