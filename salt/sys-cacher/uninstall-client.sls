{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-uninstall-client-https":
  cmd.run:
    - name: apt-cacher-ng-repo uninstall
    - stateful: True
    - runas: root
