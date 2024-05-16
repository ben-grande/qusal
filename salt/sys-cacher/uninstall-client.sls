{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if salt['cmd.shell']('command -v apt-cacher-ng-repo >/dev/null') -%}
"{{ slsdotpath }}-uninstall-client-repository-modifications":
  cmd.run:
    - name: apt-cacher-ng-repo uninstall
    - stateful: True
    - runas: root
{% endif -%}

"{{ slsdotpath }}-uninstall-client-scripts":
  file.absent:
    - name: /usr/bin/apt-cacher-ng-repo

"{{ slsdotpath }}-uninstall-client-systemd-service":
  file.absent:
    - name: /usr/lib/systemd/system/qubes-apt-cacher-ng-repo.service
