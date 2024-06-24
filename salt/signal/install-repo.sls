{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{% from 'utils/macros/install-repo.sls' import install_repo -%}
{{ install_repo(sls_path, 'signal') }}

{% endif -%}
