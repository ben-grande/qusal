{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - sys-ssh-agent.install-client

{% from 'utils/macros/install-repo.sls' import install_repo -%}
{{ install_repo(sls_path, 'terraform') }}

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - terraform
      - terraform-ls
      - vim
      - man-db

{% endif -%}
