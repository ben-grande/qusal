{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% from 'utils/macros/policy.sls' import policy_unset with context -%}
{{ policy_unset(sls_path, '75') }}
