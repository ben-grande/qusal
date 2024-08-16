{#
SPDX-FileCopyrightText: 2022 - 2023 unman <unman@thirdeyesecurity.org>
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - utils.tools.common.update
  - browser.install
  - sys-audio.install-client

"{{ slsdotpath }}-installed":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - qubes-pdf-converter
      - qubes-img-converter
      - qubes-app-shutdown-idle
      - audacious
      - calibre
      - ffmpeg
      - ffmpegthumbnailer
      - gpicview
      - mousepad
      - mpv
      - yt-dlp
      - vlc
      - xpdf
      - man-db

"{{ slsdotpath }}-etc-mimeapps.list":
  file.managed:
    - name: /etc/xdg/mimeapps.list
    - source: salt://{{ slsdotpath }}/files/browser/mimeapps.list
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-etc-mpv.conf":
  file.managed:
    - name: /etc/mpv/mpv.conf
    - source: salt://{{ slsdotpath }}/files/browser/mpv.conf
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-idle-trimleness":
  file.replace:
    - name: /usr/lib/python3/dist-packages/qubesidle/idleness_monitor.py
    - pattern: '15 \* 60'
    - repl: '3 * 60'

{% endif -%}
