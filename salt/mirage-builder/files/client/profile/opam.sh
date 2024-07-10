#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

# shellcheck disable=SC1091
if test -n "${ZSH_VERSION-}" && test -r "${HOME}/.opam/opam-init/init.zsh"
then
  . "${HOME}/.opam/opam-init/init.zsh" >/dev/null 2>&1
elif test -r "${HOME}/.opam/opam-init/init.sh"; then
  . "${HOME}/.opam/opam-init/init.sh" >/dev/null 2>&1
fi
