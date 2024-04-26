{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-uninstall-client-repository-modifications":
  cmd.run:
    - name: apt-cacher-ng-repo uninstall
    - stateful: True
    - runas: root

"{{ slsdotpath }}-uninstall-client-systemd-service":
  file.absent:
    - name: /usr/lib/systemd/system/qubes-apt-cacher-ng-repo.service
