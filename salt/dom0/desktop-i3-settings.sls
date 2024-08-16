{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] == 'dom0' -%}

{%- import slsdotpath ~ "/gui-user.jinja" as gui_user -%}

include:
  - utils.tools.common.update

"{{ slsdotpath }}-desktop-i3-settings-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - setopt: "install_weak_deps=False"
    - pkgs:
      - i3-settings-qubes

{% endif -%}
