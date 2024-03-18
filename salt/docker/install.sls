{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - docker.install-repo
  - utils.tools.common.update

{% set pkg = {
    'Debian': {
      'pkg_removed': ['docker.io', 'docker-doc', 'docker-compose',
                      'podman-docker', 'containerd', 'runc'],
    },
    'RedHat': {
      'pkg_removed': ['docker', 'docker-client', 'docker-client-latest',
                      'docker-common', 'docker-latest',
                      'docker-latest-logrotate', 'docker-logrotate',
                      'docker-selinux', 'docker-engine-selinux',
                      'docker-engine'],
    },
}.get(grains.os_family) -%}

{#
"{{ slsdotpath }}-removed-os-specific":
  pkg.removed:
    - pkgs: {{ pkg.pkg_removed|sequence|yaml }}
#}

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install-repo
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - man-db
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-buildx-plugin
      - docker-compose-plugin

"{{ slsdotpath }}-add-user-to-docker-group":
  group.present:
    - name: docker
    - addusers:
      - user

{% endif -%}
