#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

## Requires: https://github.com/mzlogin/vim-markdown-toc
set -eu

usage(){
  printf '%s\n' "Usage: ${0##*/} <file> [file ...]"
  exit 1
}

case "${1-}" in
  ""|-h|--help) usage;;
  *) ;;
esac

## vim-markdown-toc deletes lines if they are folded, can't rely on its native
## update on save.
if ! vim -e -c 'setf markdown' -c 'if !exists(":GenTocGFM") | cq | endif' -c q
then
  err_msg="error: Vim Plugin mzlogin/vim-markdown-toc isn't installed."
  printf '%s\n' "${err_msg}" >&2
  exit 1
fi


for f in "${@}"; do
  if ! test -f "${f}"; then
    printf '%s\n' "error: Not a regular file: ${f}" >&2
    exit 1
  fi
  if ! grep -q -e "^## Table of Contents$" -- "${f}"; then
    printf '%s\n' "Could not find TOC in file: ${f}, skipping" >&2
    continue
  fi
  ## This is fragile, the table of contents should have at least one block
  ## separated by an empty line before the nest heading, else it will delete
  ## the rest of the file.
  vim -c 'norm zRgg' -c '/^## Table of Contents$' -c 'norm jd}k' \
      -c ':GenTocGFM' -c 'norm ddgg' -c wq -- "${f}"
  printf '%s\n' "Updated TOC in file: ${f}"
done
