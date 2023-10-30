{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{% from 'utils/macros/install-repo.sls' import install_repo -%}
{{ install_repo(sls_path, 'docker') }}

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

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
    - refresh: True
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

"{{ slsdotpath }}-user-in-docker-group":
  user.present:
    - name: user
    - groups:
      - user
      - qubes
      - docker

{% endif -%}
