{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

The GUI agent will break, use qvm-console-dispvm to get a terminal.

https://www.kicksecure.com/wiki/Security-misc
https://www.kicksecure.com/wiki/Hardened-kernel
https://www.kicksecure.com/wiki/Hardened_Malloc
https://www.kicksecure.com/wiki/Operating_System_Hardening
https://www.kicksecure.com/wiki/Linux_Kernel_Runtime_Guard_LKRG
https://www.qubes-os.org/doc/managing-vm-kernels/#distribution-kernel
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - kicksecure-minimal.install

"{{ slsdotpath }}-developers-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
      - sls: kicksecure-minimal.install
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-kernel-vm-support
      - linux-image-amd64
      - linux-headers-amd64
      - grub2
      - lkrg
      - tirdad

## Breaks browsers.
"{{ slsdotpath }}-hardened-malloc-preload":
  file.managed:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: /etc/ld.so.preload
    - source: salt://{{ slsdotpath }}/files/template/ld.so.preload
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

## Does not break (maybe), present here because it is not the default.
"{{ slsdotpath }}-permission-hardener-conf":
  file.managed:
    - name: /etc/permission-hardener.d/40_qusal.conf
    - source: salt://{{ slsdotpath }}/files/template/permission-hardener.d/40_qusal.conf
    - mode: '0600'
    - user: root
    - group: root
    - makedirs: True

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

"{{ slsdotpath }}-distribution-kernel":
  cmd.run:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: grub-install /dev/xvda
    - runas: root

{% endif %}
