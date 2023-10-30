{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dotfiles.copy-x11
  - ssh.install

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - socat

{% set pkg = {
    'Debian': {
      'pkg': ['libpam-systemd', 'procps', 'openssh-client'],
    },
    'RedHat': {
      'pkg': ['systemd-pam', 'procps-ng', 'openssh-clients'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-agent-bin-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/server/bin
    - name: /usr/bin
    - file_mode: '0755'
    - user: root
    - group: root

"{{ slsdotpath }}-agent-user-systemd-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/server/systemd/
    - name: /usr/lib/systemd/user/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root

"{{ slsdotpath }}-agent-start-systemd-dbus-login-service":
  service.running:
    - name: dbus-org.freedesktop.login1.service

"{{ slsdotpath }}-agent-start-systemd-user-services-on-boot":
  cmd.run:
    - require:
      - service: "{{ slsdotpath }}-agent-start-systemd-dbus-login-service"
    - name: loginctl enable-linger user

"{{ slsdotpath }}-install-rpc-service":
  file.managed:
    - name: /etc/qubes-rpc/qusal.SshAgent
    - source: salt://{{ slsdotpath }}/files/rpc/qusal.SshAgent
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-skel-create-ssh-directory":
  file.directory:
    - name: /etc/skel/.ssh
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-skel-create-keys-directory":
  file.directory:
    - name: /etc/skel/.ssh/identities.d
    - mode: '0700'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
