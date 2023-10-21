{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11

"{{ slsdotpath }}-create-keys-directory":
  file.directory:
    - name: /home/user/keys
    - mode: '0700'
    - user: user
    - group: user

{% endif %}
