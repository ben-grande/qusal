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

"{{ slsdotpath }}-install-client-repository-definitions":
  cmd.run:
    - name: apt-cacher-ng-repo
    - stateful: True
    - runas: root
    - require:
      - file: "{{ slsdotpath }}-install-client-scripts"

"{{ slsdotpath }}-install-client-systemd":
  file.managed:
    - name: /usr/lib/systemd/system/qusal-apt-cacher-ng-repo.service
    - source: salt://{{ slsdotpath }}/files/client/systemd/qusal-apt-cacher-ng-repo.service
    - mode: "0644"
    - group: root
    - user: root
    - makedirs: True

"{{ slsdotpath }}-install-client-systemd-start-qusal-apt-cacher-ng-repo.service":
  service.enabled:
    - name: qusal-apt-cacher-ng-repo.service
