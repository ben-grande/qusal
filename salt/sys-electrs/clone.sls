{#
SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% from 'utils/macros/clone-template.sls' import clone_template -%}
{{ clone_template('debian-minimal', sls_path) }}
{{ clone_template('debian-minimal', 'electrs-builder', include_create=False) }}

{#
# editorconfig-checker-disable
TODO: Recheck: Cargo index fetch isis too big to be fetched over tor.
Impossible to fetch Cargo index over tor as of Bookworm Cargo 1.65.
Cargo >=1.68 does support "sparse" registry protocol,
  https://blog.rust-lang.org/inside-rust/2023/01/30/cargo-sparse-protocol.html
This would partially solve the issue, shallow clone is still an open issue.

Command "cargo --config http.proxy=\"socks5h://10.152.152.10:9400\" build --locked --release --no-default-features" run

Updating crates.io index
warning: spurious network error (2 tries remaining): early EOF; class=Net (12); code=Eof (-20)
warning: spurious network error (1 tries remaining): [56] Failure when receiving data from the peer (GnuTLS recv error (-9): Error decoding the received TLS packet.); class=Net (12) # noqa: 204
error: Unable to update registry `crates-io`

Caused by:
  failed to fetch `https://github.com/rust-lang/crates.io-index`

Caused by:
  network failure seems to have happened
  if a proxy or similar is necessary `net.git-fetch-with-cli` may help here
    https://doc.rust-lang.org/cargo/reference/config.html#netgit-fetch-with-cli

Caused by:
  [18] Transferred a partial file; class=Net (12)
#}
{#
{{ clone_template(['debian-minimal', 'whonix-workstation'], sls_path) }}
{{ clone_template('whonix-workstation', 'electrs-builder', include_create=False) }}
# editorconfig-checker-enable
#}
