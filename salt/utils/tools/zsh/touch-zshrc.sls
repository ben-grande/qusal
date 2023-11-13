{#
SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

# zsh complains if there is no .zshrc when.
# Only useful if not using the dotfiles but installing zsh.

"{{ slsdotpath }}-touch-home-zshrc":
  file.touch:
    - name: /home/user/.zshrc

"{{ slsdotpath }}-touch-skel-zshrc":
  file.touch:
    - name: /etc/skel/.zshrc
