{#
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}
include:
  - utils.tools.common.update

"{{ slsdotpath }}-installed-rust-deps":
  pkg.installed:
    - require:
      - sls: utils.tools.common.update
    - install_recommends: False
    - skip_suggestions: True
    - setopt: "install_weak_deps=False"
    - pkgs:
      - curl
      - build-essential

"{{ slsdotpath }}-installed-rustup":
  cmd.run:
    - name: curl --proxy 127.0.0.1:8082 --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    - runas: user
    - creates: /home/user/.cargo/bin/rustup
    - require:
      - pkg: "{{ slsdotpath }}-installed-rust-deps"

"{{ slsdotpath }}-rust-profile":
  file.append:
    - name: /home/user/.zshrc
    - text: |
        # Rust environment
        export PATH="$HOME/.cargo/bin:$PATH"
    - user: user
    - require:
      - cmd: "{{ slsdotpath }}-installed-rustup"
{% endif %}
