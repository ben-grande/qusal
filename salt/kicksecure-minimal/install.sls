{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

https://www.kicksecure.com/wiki/Debian
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - kicksecure-minimal.install-repo
  - utils.tools.common.update
  - utils.tools.zsh

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: kicksecure-minimal.install-repo
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - kicksecure-qubes-cli

"{{ slsdotpath }}-remove-debian-default-sources.list":
  file.comment:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: /etc/apt/sources.list
    - regex: ^\s*deb
    - ignore_missing: True

{% endif %}
