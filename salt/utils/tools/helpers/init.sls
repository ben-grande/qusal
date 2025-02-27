{#
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-helpers":
  file.recurse:
    - name: /usr/bin/
    - source: salt://utils/tools/helpers/files/bin
    - user: root
    - group: root
    - file_mode: '0755'
    - dir_mode: '0755'
    - keep_symlinks: True
    - force_symlinks: True
