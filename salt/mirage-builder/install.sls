{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-ssh
  - dotfiles.copy-git
  - sys-pgp.install-client
  - sys-git.install-client
  - sys-ssh-agent.install-client
  - docker.install

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      ## https://github.com/mirage/qubes-mirage-firewall/blob/main/Dockerfile
      - qubes-core-agent-networking
      - ca-certificates
      - bash-completion
      - man-db
      - vim
      - git
      - patch
      - unzip
      - bzip2
      - make
      - gcc
      - g++
      - libc-dev-bin
      - opam
      - ocaml

"{{ slsdotpath }}-opam-completion-and-hooks":
  file.managed:
    - name: /etc/profile.d/opam.sh
    - source: salt://{{ slsdotpath }}/files/client/profile/opam.sh
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
