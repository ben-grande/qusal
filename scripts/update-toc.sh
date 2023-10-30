#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: GPL-3.0-or-later

## Requires: https://github.com/mzlogin/vim-markdown-toc
set -eu

usage(){
  echo "Usage: ${0##*/} <file> [file ...]"
  exit 1
}

case "${1-}" in
  ""|-h|--?help) usage;;
esac

## vim-markdown-toc deletes lines if they are folded, can't rely on its native
## update on save.
if ! vim -e -c 'setf markdown' -c 'if !exists(":GenTocGFM") | cq | endif' -c q
then
  echo "Error: Vim Plugin mzlogin/vim-markdown-toc is not installed."
  exit 1
fi


for f in "$@"; do
  if ! grep -q "^## Table of Contents$" "$f"; then
    echo "Could not find table of contents on file: $f" >&2; exit 1
  fi
  vim -c 'norm zRgg' -c '/^## Table of Contents$' -c 'norm jd}k' -c ':GenTocGFM' -c 'norm ddgg' -c wq -- "${f}"
done
