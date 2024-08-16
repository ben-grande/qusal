{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-core-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
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
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs: {{ pkg.pkg|sequence|yaml }}

{% endif -%}
