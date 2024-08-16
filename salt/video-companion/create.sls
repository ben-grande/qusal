{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-dom0-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-video-companion-dom0
