{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - .install-repo
  - utils.tools.common.update

"{{ slsdotpath }}-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/server/systemd/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: {{ slsdotpath }}.install-repo
      - sls: utils.tools.common.update
      - file: "{{ slsdotpath }}-systemd"
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - tailscale
      - bash-completion
      - man-db

"{{ slsdotpath }}-unmask-tailscaled":
  service.unmasked:
    - name: tailscaled
    - runtime: False

"{{ slsdotpath }}-enable-tailscaled":
  service.enabled:
    - name: tailscaled

"{{ slsdotpath }}-bind-dirs":
  file.managed:
    - name: /etc/qubes-bind-dirs.d/50-{{ slsdotpath }}.conf
    - source: salt://{{ slsdotpath }}/files/server/qubes-bind-dirs.d/50-{{ slsdotpath }}.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
