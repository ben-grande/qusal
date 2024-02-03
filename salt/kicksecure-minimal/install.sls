{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

https://www.kicksecure.com/wiki/Debian
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - kicksecure-minimal.install-repo
  - sys-cacher.install-client
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
      - kicksecure-qubes-cli

"{{ slsdotpath }}-remove-debian-default-sources.list":
  file.comment:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: /etc/apt/sources.list
    - regex: "^\s*deb"
    - ignore_missing: True

{% endif %}
