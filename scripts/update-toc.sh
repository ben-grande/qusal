#!/bin/sh

## SPDX-FileCopyrightText: 2023 Qusal contributors
##
## SPDX-License-Identifier: GPL-3.0-or-later

## Requires: https://github.com/mzlogin/vim-markdown-toc
set -eu

for f in "$@"; do
  if ! grep -q "^## Table of Contents$" "$f"; then
    echo "Could not find table of contents on file: $f" >&2; exit 1
  fi
  vim -c 'norm zRgg' -c '/^## Table of Contents$' -c 'norm jd}k' -c ':GenTocGFM' -c 'norm ddgg' -c wq -- "${f}"
done
