{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11

"{{ slsdotpath }}-create-ssh-directory":
  file.directory:
    - name: /home/user/.ssh
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-create-keys-directory":
  file.directory:
    - name: /home/user/.ssh/identities.d
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

{% endif %}
