{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-revert-default_guivm-to-dom0":
  cmd.run:
    - name: qubes-prefs default_guivm dom0
