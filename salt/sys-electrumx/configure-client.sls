{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-disables-connections-to-random-servers":
  cmd.run:
    - name: electrum --offline setconfig auto_connect false
    - runas: user

"{{ slsdotpath }}-connect-to-one-server-only":
  cmd.run:
    - name: electrum --offline setconfig oneserver true
    - runas: user

"{{ slsdotpath }}-connect-to-server-listening-on-localhost":
  cmd.run:
    - name: electrum --offline setconfig server 127.0.0.1:50001:t
    - runas: user

{% endif -%}
