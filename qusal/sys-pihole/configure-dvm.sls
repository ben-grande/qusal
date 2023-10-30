{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.com>
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' %}

"{{ slsdotpath }}-dvm-rc.local":
  file.append:
    - name: /rw/config/rc.local
    - text: "qvm-connect-tcp 80:@default:80"

{% endif -%}
