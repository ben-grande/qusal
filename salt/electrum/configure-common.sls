{#
SPDX-FileCopyrightText: 2024 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-sh

"{{ slsdotpath }}-do-not-check-for-updates":
  cmd.run:
    - name: electrum --offline setconfig check_updates false
    - runas: user

"{{ slsdotpath }}-show-contacts-tab":
  cmd.run:
    - name: electrum --offline setconfig show_contacts_tab true
    - runas: user

"{{ slsdotpath }}-show-addresses-tab":
  cmd.run:
    - name: electrum --offline setconfig show_addresses_tab true
    - runas: user

"{{ slsdotpath }}-show-utxo-tab":
  cmd.run:
    - name: electrum --offline setconfig show_utxo_tab true
    - runas: user

"{{ slsdotpath }}-show-notes-tab":
  cmd.run:
    - name: electrum --offline setconfig show_notes_tab true
    - runas: user

{% endif -%}
