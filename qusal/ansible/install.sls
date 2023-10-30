{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.zsh
  - ssh.install

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - ansible
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
    - refresh: True
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
    - source: salt://{{ slsdotpath }}/files/minion/99-sshd-ansible.conf
    - mode: '0644'
    - user: root
    - group: root

{% endif -%}
