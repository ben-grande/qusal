{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-x11
  - dotfiles.copy-sh

## https://download.electrum.org/VERSION/Electrum-VERSION.tar.gz(.asc)
{% set electrum_version = '4.5.5' -%}
{% set electrum_url_dir = 'https://download.electrum.org/' ~ electrum_version ~ '/' -%}
{% set electrum_archive_dir = 'Electrum-' ~ electrum_version -%}
{% set electrum_file_archive = electrum_archive_dir ~ '.tar.gz' -%}
{% set electrum_file_sig = electrum_file_archive ~ '.asc' -%}
{% set electrum_url_archive = electrum_url_dir ~ electrum_file_archive -%}
{% set electrum_url_sig = electrum_url_dir ~ electrum_file_sig -%}

"{{ slsdotpath }}-gnupg-home":
  file.directory:
    - name: /home/user/.gnupg/electrum
    - user: user
    - group: user
    - mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-save-keys":
  file.recurse:
    - require:
      - file: "{{ slsdotpath }}-gnupg-home"
    - name: /home/user/.gnupg/electrum/download/
    - source: salt://{{ slsdotpath }}/files/client/keys/
    - user: user
    - group: user
    - file_mode: '0600'
    - dir_mode: '0700'
    - makedirs: True

"{{ slsdotpath }}-import-keys":
  cmd.run:
    - require:
      - file: "{{ slsdotpath }}-save-keys"
    - name: gpg --status-fd=2 --homedir . --import download/*.asc
    - cwd: /home/user/.gnupg/electrum
    - runas: user
    - success_stderr: IMPORT_OK

"{{ slsdotpath }}-import-ownertrust":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-import-keys"
    - name: gpg --homedir . --import-ownertrust download/otrust.txt
    - cwd: /home/user/.gnupg/electrum
    - runas: user

"{{ slsdotpath }}-remove-failed-download-or-verification":
  file.absent:
    - name: /tmp/electrum-download
    - onfail:
      - cmd: "{{ slsdotpath }}-download"
      - cmd: "{{ slsdotpath }}-gpg-verify"

"{{ slsdotpath }}-make-download-dir":
  file.directory:
    - name: /tmp/electrum-download
    - mode: '0755'
    - user: user
    - group: user
    - makedirs: True

## file.managed does not fetch URLs through a SocksProxy.
"{{ slsdotpath }}-download":
  cmd.run:
    - require:
      - file: "{{ slsdotpath }}-make-download-dir"
    - name: |
        timeout --foreground 1200 curl.anondist-orig \
          --connect-timeout 60 \
          --tlsv1.3 --proto =https \
          --fail --fail-early \
          --proxy "socks5h://10.152.152.10:9400" \
          --parallel --parallel-immediate \
          --no-progress-meter --silent --show-error \
          -O "{{ electrum_url_archive }}" \
          -O "{{ electrum_url_sig }}"
    - cwd: /tmp/electrum-download
    - runas: user

"{{ slsdotpath }}-gpg-verify":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-download"
      - cmd: "{{ slsdotpath }}-import-ownertrust"
    ## Multiple detached signatures has bad UX with GPG.
    - env:
      - GNUPGHOME: /home/user/.gnupg/electrum/
    - name: gpg --status-fd=2 --verify "{{ electrum_file_sig }}"
    - cwd: /tmp/electrum-download
    - runas: user

"{{ slsdotpath }}-extract-archive":
  archive.extracted:
    - require:
      - cmd: "{{ slsdotpath }}-gpg-verify"
    - name: /tmp/
    - source: /tmp/electrum-download/{{ electrum_file_archive }}
    - overwrite: True
    - clean: True

"{{ slsdotpath }}-generate-payment-request":
  cmd.run:
    - require:
      - archive: "{{ slsdotpath }}-extract-archive"
    - name: ./contrib/generate_payreqpb2.sh
    - cwd: /tmp/{{ electrum_archive_dir }}

"{{ slsdotpath }}-copy-files-to-template":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-generate-payment-request"
    - name: qrexec-client-vm -T -- @default qusal.InstallElectrum /usr/lib/qubes/qfile-agent electrum/ run_electrum electrum.desktop
    - cwd: /tmp/{{ electrum_archive_dir }}
    - runas: user

{% endif -%}
