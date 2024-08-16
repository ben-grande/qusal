{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-receiver-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      {% if grains['os_family']|lower == 'debian' -%}
      - qubes-video-companion
      {% else %}
      - qubes-video-companion-receiver
      {% endif %}
      {% if '.qubes.' not in salt['cmd.shell']('uname -r') and grains['os_family']|lower == 'debian' -%}
      - v4l2loopback-dkms
      {% endif %}
      ## Undeclared dependencies
      - qubes-core-agent-passwordless-root
      - dunst
      - libnotify-bin

{% endif %}
