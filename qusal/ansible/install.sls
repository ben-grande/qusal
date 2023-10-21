{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.zsh

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
      {% if grains['os_family']|lower == 'debian' -%}
      - openssh-client
      - vim-nox
      - python3-selinux
      {% elif grains['os_family']|lower == 'redhat' -%}
      - openssh-clients
      - vim-enhanced
      - vim-ansible
      {% else -%}
      - openssh-client
      - vim
      {% endif -%}
      - python3-argcomplete
      - python3-jmespath
      - openssh-server
      - qubes-core-agent-passwordless-root
      - bash-completion
      - man-db

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
