{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['os_family']|lower == 'debian' -%}
{% for repo in salt['file.find']('/etc/apt/sources.list.d/', name='*(list|sources)') -%}
  {{ repo }}_baseurl:
      file.replace:
        - name: {{ repo }}
        - pattern: 'http://HTTPS/'
        - repl: 'https:'
        - flags: [ 'IGNORECASE', 'MULTILINE' ]
        - backup: False
{% endfor -%}

  /etc/apt/sources.list:
    file.replace:
      - name: /etc/apt/sources.list
      - pattern: 'http://HTTPS/'
      - repl: 'https:'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False

{% elif grains['os_family']|lower == 'arch' -%}
  pacman:
    file.replace:
      - names:
        - /etc/pacman.d/mirrorlist
        - /etc/pacman.d/99-qubes-repository-4.1.conf.disabled
      - pattern: 'http://HTTPS///'
      - repl: 'https://'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False


{% elif grains['os_family']|lower == 'redhat' -%}
{% for repo in salt['file.find']('/etc/yum.repos.d/', name='*repo*') -%}
{{ repo }}_baseurl:
    file.replace:
      - name: {{ repo }}
      - pattern: 'baseurl(.*)http://HTTPS/'
      - repl: 'baseurl\1https:'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False

{{ repo }}_metalink:
    file.replace:
      - name: {{ repo }}
      - pattern: 'metalink=http://HTTPS///(.*)'
      - repl: 'metalink=https://\1'
      - flags: [ 'IGNORECASE', 'MULTILINE' ]
      - backup: False

{% endfor -%}
{% endif -%}
