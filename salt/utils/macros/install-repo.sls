{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{#
Install repositories with ease.

Usage:
1: Import this template:
{% from 'utils/macros/install-repo.sls' import install_repo -%}

2: Set template to clone from and the clone name:
{{ install_repo(sls_path, 'chrome') }}

If sls_path is 'browser', then this would install the repo from:
  Source directory:
    salt://browser/files/repo/

  Debian:
    chrome.sources -> /etc/apt/sources.list.d/chrome.sources
    chrome.asc -> /usr/share/keyrings/chrome.asc
  Fedora:
    chrome.yum.repo -> /etc/yum.repos.d/chrome.repo
    chrome.yum.asc -> /etc/pki/rpm-gpg/RPM-GPG-KEY-chrome
#}

{% macro install_repo(name, repo) -%}

{% if grains['os_family']|lower == 'debian' -%}

"{{ name }}-install-{{ repo }}-keyring":
  file.managed:
    - name: /usr/share/keyrings/{{ repo }}.asc
    - source: salt://{{ name }}/files/repo/{{ repo }}.asc
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ name }}-remove-{{ repo }}-old-format":
  file.absent:
    - require:
      - file: "{{ name }}-install-{{ repo }}-keyring"
    - name: /etc/apt/sources.list.d/{{ repo }}.list

"{{ name }}-install-{{ repo }}-repository":
  file.managed:
    - require:
      - file: "{{ name }}-install-{{ repo }}-keyring"
      - file: "{{ name }}-remove-{{ repo }}-old-format"
    - name: /etc/apt/sources.list.d/{{ repo }}.sources
    - source: salt://{{ name }}/files/repo/{{ repo }}.sources
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% elif grains['os_family']|lower == 'redhat' -%}

"{{ name }}-install-{{ repo }}-keyring":
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-{{ repo }}
    - source: salt://{{ name }}/files/repo/{{ repo }}.yum.asc
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ name }}-install-{{ repo }}-repository":
  file.managed:
    - require:
      - file: "{{ name }}-install-{{ repo }}-keyring"
    - name: /etc/yum.repos.d/{{ repo }}.repo
    - source: salt://{{ name }}/files/repo/{{ repo }}.yum.repo
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}

{% if salt['cmd.retcode']('command -v apt-cacher-ng-repo >/dev/null') == 0 -%}
"{{ name }}-run-apt-cacher-ng-repo":
  cmd.run:
    - name: apt-cacher-ng-repo
{% endif -%}

{% endmacro -%}
