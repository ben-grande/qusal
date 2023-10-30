{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-core-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-core-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - qubes-core-agent-passwordless-root
      - bash-completion
      - make
      - rpmlint
      - rpm
      - licensecheck
      - devscripts

{% set pkg = {
    'Debian': {
      'pkg': ['equivs', 'dctrl-tools', 'build-essential' 'debhelper', 'quilt',
              'lintian', 'mmdebstrap'],
    },
    'RedHat': {
      'pkg': ['rpmdevtools', 'rpm-sign', 'rpm-build', 'fedora-packager',
              'fedora-review'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-core-installed-os-specific":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
