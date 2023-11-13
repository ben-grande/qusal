{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

"{{ slsdotpath }}-firewall":
  cmd.run:
    - require:
      - qvm: {{ slsdotpath }}
    - name: |
        qvm-check -q --running {{ slsdotpath }} && qvm-pause {{ slsdotpath }}
        qvm-firewall {{ slsdotpath }} reset
        qvm-firewall {{ slsdotpath }} del --rule-no 0
        qvm-check -q --running {{ slsdotpath }} && qvm-unpause {{ slsdotpath }}
        qvm-firewall {{ slsdotpath }} add accept signal.org
        qvm-firewall {{ slsdotpath }} add accept storage.signal.org
        qvm-firewall {{ slsdotpath }} add accept chat.signal.org
        qvm-firewall {{ slsdotpath }} add accept cdn.signal.org
        qvm-firewall {{ slsdotpath }} add accept cdn2.signal.org
        qvm-firewall {{ slsdotpath }} add accept sfu.voip.signal.org
        qvm-firewall {{ slsdotpath }} add accept turn.voip.signal.org
        qvm-firewall {{ slsdotpath }} add accept turn2.voip.signal.org
        qvm-firewall {{ slsdotpath }} add accept turn3.voip.signal.org
