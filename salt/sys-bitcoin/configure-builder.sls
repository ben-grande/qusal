{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

{%- import slsdotpath ~ "/version.jinja" as version -%}

## https://bitcoincore.org/bin/bitcoin-core-VERSION/
## bitcoin-VERSION-x86_64-linux-gnu.tar.gz|SHA256SUMS|SHA256SUMS.asc
{% set bitcoin_version = version.version -%}
{% set bitcoin_url_dir = 'https://bitcoincore.org/bin/bitcoin-core-' ~ bitcoin_version ~ '/' -%}
{% set bitcoin_archive_dir = 'bitcoin-' ~ bitcoin_version -%}
{% set bitcoin_file_archive = bitcoin_archive_dir ~ '-x86_64-linux-gnu.tar.gz' -%}
{% set bitcoin_file_shasum = 'SHA256SUMS' -%}
{% set bitcoin_file_shasum_sig = bitcoin_file_shasum ~ '.asc' -%}
{% set bitcoin_url_archive = bitcoin_url_dir ~ bitcoin_file_archive -%}
{% set bitcoin_url_shasum = bitcoin_url_dir ~ bitcoin_file_shasum -%}
{% set bitcoin_url_shasum_sig = bitcoin_url_dir ~ bitcoin_file_shasum_sig -%}

include:
  - .configure-builder-common

"{{ slsdotpath }}-remove-failed-download-or-verification":
  file.absent:
    - name: /tmp/bitcoin-download
    - onfail:
      - cmd: "{{ slsdotpath }}-download"
      - cmd: "{{ slsdotpath }}-gpg-verify-shasum"
      - cmd: "{{ slsdotpath }}-shasum-check"

"{{ slsdotpath }}-make-download-dir":
  file.directory:
    - name: /tmp/bitcoin-download
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
          -O "{{ bitcoin_url_archive }}" \
          -O "{{ bitcoin_url_shasum }}" \
          -O "{{ bitcoin_url_shasum_sig }}"
    - cwd: /tmp/bitcoin-download
    - runas: user

"{{ slsdotpath }}-gpg-verify-shasum":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-download"
      - cmd: "{{ slsdotpath }}-import-ownertrust"
    ## Multiple detached signatures has bad UX with GPG.
    - name: |
        trusted_sigs_number="4"
        read_sigs_number="$(GNUPGHOME=/home/user/.gnupg/bitcoin/ gpg --status-fd=2 --verify SHA256SUMS.asc 2>&1 | grep -c -e "^\[GNUPG:\] GOODSIG \S\+ ")"
        if test "${trusted_sigs_number}" != "${read_sigs_number}"; then
          exit 1
        fi
    - cwd: /tmp/bitcoin-download
    - runas: user

"{{ slsdotpath }}-shasum-check":
  cmd.run:
    - require:
      - cmd: "{{ slsdotpath }}-gpg-verify-shasum"
    - name: sha256sum --check --ignore-missing {{ bitcoin_file_shasum }}
    - cwd: /tmp/bitcoin-download
    - runas: user

"{{ slsdotpath }}-extract-archive":
  archive.extracted:
    - require:
      - cmd: "{{ slsdotpath }}-shasum-check"
    - name: /tmp/
    - source: /tmp/bitcoin-download/{{ bitcoin_file_archive }}
    - overwrite: True
    - clean: True

"{{ slsdotpath }}-copy-files-to-template":
  cmd.run:
    - require:
      - archive: "{{ slsdotpath }}-extract-archive"
    - name: qrexec-client-vm -T -- @default qusal.InstallBitcoin /usr/lib/qubes/qfile-agent /tmp/{{ bitcoin_archive_dir }}/*
    - runas: user

{% endif -%}
