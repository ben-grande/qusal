{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{%- import slsdotpath ~ "/template.jinja" as template -%}

{% from 'utils/macros/clone-template.sls' import clone_template -%}
{{ clone_template('debian-minimal', template.template, prefix='') }}
