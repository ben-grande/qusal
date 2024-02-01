{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

Most likely the GUI agent will break, use qvm-console-dispvm to get a terminal.
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - kicksecure-minimal.install

"{{ slsdotpath }}-developers-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-developers-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - lkrg
      - tirdad

## Breaks systemd service qubes-gui-agent
"{{ slsdotpath }}-proc-hidepid-enabled":
  service.enabled:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: proc-hidepid

## Breaks systemd services xen and systemd-binfmt
"{{ slsdotpath }}-harden-module-loading-enabled":
  service.enabled:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: harden-module-loading

## Breaks systemd services qubes-gui-agent and user@1000
"{{ slsdotpath }}-hide-hardware-info-enabled":
  service.enabled:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: hide-hardware-info

"{{ slsdotpath }}-hide-hardware-info-conf":
  file.managed:
    - require:
      - service: "{{ slsdotpath }}-hide-hardware-info-enabled"
    - name: /etc/hide-hardware-info.d/40_qusal.conf
    - source: salt://{{ slsdotpath }}/files/template/hide-hardware-info.d/40_qusal.conf
    - mode: '0600'
    - user: root
    - group: root
    - makedirs: True

## Service ExecStart command-line not reading grub option
"{{ slsdotpath }}-remount-secure-enabled":
  service.enabled:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: remount-secure

"{{ slsdotpath }}-update-grub":
  cmd.run:
    - require:
      - file: "{{ slsdotpath }}-remount-secure-grub-cfg"
    - name: update-grub
    - runas: root

{% endif %}
