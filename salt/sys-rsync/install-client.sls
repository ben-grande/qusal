{#
SPDX-FileCopyrightText: 2022 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

"{{ slsdotpath }}-client-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-client-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - rsync

"{{ slsdotpath }}-client-systemd":
  file.recurse:
    - name: /usr/lib/systemd/system/
    - source: salt://{{ slsdotpath }}/files/client/systemd/
    - dir_mode: '0755'
    - file_mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-client-systemd-start-qubes-rsync-forwarder.socket":
  service.enabled:
    - name: qubes-rsync-forwarder.socket

{% endif -%}
