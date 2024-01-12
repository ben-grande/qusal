{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later

https://www.kicksecure.com/wiki/Debian
https://www.kicksecure.com/wiki/Security-misc
https://www.kicksecure.com/wiki/Hardened-kernel
https://www.kicksecure.com/wiki/Hardened_Malloc
https://www.kicksecure.com/wiki/Operating_System_Hardening
https://www.kicksecure.com/wiki/Linux_Kernel_Runtime_Guard_LKRG
https://www.qubes-os.org/doc/managing-vm-kernels/#distribution-kernel
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
      - lkrg-dkms
      - hardened-kernel
      - tirdad
      - linux-image-amd64
      - linux-headers-amd64
      - grub2
      - qubes-kernel-vm-support

"{{ slsdotpath }}-remove-debian-default-sources.list":
  file.absent:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: /etc/apt/sources.list

"{{ slsdotpath }}-permission-hardener-enabled":
  service.enabled:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: permission-hardening
    #- name: permission-hardener

"{{ slsdotpath }}-permission-hardener-conf":
  file.managed:
    - require:
      - service: "{{ slsdotpath }}-permission-hardener-enabled"
    - name: /etc/permission-hardener.d/40_qusal.conf
    - source: salt://{{ slsdotpath }}/files/template/permission-hardener.d/40_qusal.conf
    - mode: '0600'
    - user: root
    - group: root
    - makedirs: True

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

"{{ slsdotpath }}-distribution-kernel":
  cmd.run:
    - require:
      - pkg: "{{ slsdotpath }}-installed"
    - name: grub-install /dev/xvda
    - runas: root

{% endif %}
