{#
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: GPL-3.0-or-later
#}

{% from 'utils/macros/clone-template.sls' import clone_template -%}
{{ clone_template('debian-minimal', sls_path) }}
