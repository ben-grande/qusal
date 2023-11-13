{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% from 'utils/macros/policy.sls' import policy_unset with context -%}
{{ policy_unset(sls_path, '75') }}
