#!/bin/sh

## SPDX-FileCopyrightText: 2023 Qusal contributors
##
## SPDX-License-Identifier: GPL-3.0-or-later

set -eu

prg="$0"
if ! test -e "$prg"; then
  case "$prg" in
    (*/*) exit 1;;
    (*) prg=$(command -v -- "$prg") || exit;;
  esac
fi
dir="$(cd -P -- "$(dirname -- "$prg")" && pwd -P)" || exit 1
prg="$dir/$(basename -- "$prg")" || exit 1
cd -- "$dir" || exit 1

usage(){
  printf '%s\n' "Usage: ${0##*/} [-h|--help] DIR [DIR2...]"
  printf '%s\n' "Example: ${0##*/}             # deploy all"
  printf '%s\n' "Example: ${0##*/} sh vim ...  # deploy specific dirs"
}

case "${1-}" in
  -h|--help) usage; exit 1;;
  ""|--all) args="$(find . -maxdepth 1 -type d)";;
  *) args="${*}";;
esac

for dir in $args; do
  case "${dir##*/}" in "."|"..") continue;; esac
  dir="${dir%*/}"
  test -f "$dir" && continue
  if ! test -d "$dir"; then
    printf '%s\n' "Directory doesn't exist: '$dir'." >&2
    exit 1
  fi
  for file in "$dir"/.*; do
    test -e "$file" || continue
    case "${file##*/}" in "."|"..") continue;; esac
    cp -rv "$file" "$HOME"
  done
done
