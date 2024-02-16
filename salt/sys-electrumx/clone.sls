{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% from 'utils/macros/clone-template.sls' import clone_template -%}
{{ clone_template(['debian-minimal', 'whonix-workstation'], sls_path) }}
{{ clone_template('whonix-workstation', 'electrumx-builder', include_create=False) }}
