{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-shutdown":
  qvm.shutdown:
    - name: {{ slsdotpath }}
    - flags:
      - force

{% from 'utils/macros/policy.sls' import policy_unset with context -%}
{{ policy_unset(sls_path, '80') }}
