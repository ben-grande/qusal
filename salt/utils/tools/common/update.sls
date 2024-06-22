{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if salt['cmd.retcode']('command -v apt-cacher-ng-repo >/dev/null') == 0 -%}
"common-update-run-apt-cacher-ng-repo":
  cmd.run:
    - name: apt-cacher-ng-repo
{% endif -%}

"common-updated":
  pkg.uptodate:
    - refresh: True
