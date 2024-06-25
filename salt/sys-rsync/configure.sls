{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

include:
  - dev.home-cleanup

"{{ slsdotpath }}-creates-local-rsync-configuration-dir":
  file.directory:
    - name: /usr/local/etc/rsync.d
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-creates-archive-dir":
  file.directory:
    - name: /home/user/archive
    - mode: '0777'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-creates-shared-dir":
  file.directory:
    - name: /home/user/shared
    - mode: '0777'
    - user: user
    - group: user
    - makedirs: True
