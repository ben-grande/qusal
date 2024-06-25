{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-install-client-scripts":
  file.recurse:
    - name: /usr/bin/
    - source: salt://{{ slsdotpath }}/files/client/bin/
    - file_mode: "0755"
    - group: root
    - user: root
    - makedirs: True

"{{ slsdotpath }}-uninstall-client-repository-modifications":
  cmd.run:
    - require:
      - file: "{{ slsdotpath }}-install-client-scripts"
    - name: apt-cacher-ng-repo uninstall
    - stateful: True
    - runas: root

"{{ slsdotpath }}-uninstall-client-scripts":
  file.absent:
    - name: /usr/bin/apt-cacher-ng-repo

"{{ slsdotpath }}-uninstall-client-systemd-service":
  file.absent:
    - name: /usr/lib/systemd/system/qusal-apt-cacher-ng-repo.service
