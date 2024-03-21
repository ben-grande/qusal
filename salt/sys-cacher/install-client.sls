{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-install-client-tool":
  file.managed:
    - name: /usr/bin/apt-cacher-ng-repo
    - source: salt://{{ slsdotpath }}/files/client/bin/apt-cacher-ng-repo
    - mode: "0755"
    - group: root
    - user: root
    - makedirs: True

"{{ slsdotpath }}-install-client-https":
  cmd.run:
    - name: apt-cacher-ng-repo install
    - stateful: True
    - runas: root
