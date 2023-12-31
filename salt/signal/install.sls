{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{% from 'utils/macros/install-repo.sls' import install_repo -%}
{{ install_repo(sls_path, 'signal') }}

include:
  - dotfiles.copy-x11
  - sys-audio.install-client

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
      - qubes-core-agent-thunar
      - thunar
      - signal-desktop
      - zenity
      - dunst
      - libatk1.0-0
      - libatk-bridge2.0-0
      - libgtk-4-1

{% endif -%}
