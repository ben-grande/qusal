#!/bin/sh

## SPDX-FileCopyrightText: 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

key_dir="${KEY_DIR:-"salt/qubes-builder/files/client/qusal/keys"}"
key_suffix="${KEY_SUFFIX:-".asc"}"

usage(){
  printf '%s\n' "Usage: ${0##*/} [REV...]
Info:
  Default key directory (KEY_DIR): '${key_dir}'
  Default key suffix (KEY_SUFFIX): '${key_suffix}'
Example:
  ${0##*/}                           # HEAD
  ${0##*/} HEAD                      # HEAD
  ${0##*/} a                         # revision 'a'
  ${0##*/} \$(git rev-list HEAD~5..)  # 5 revs before and until HEAD
  ${0##*/} \$(git rev-list  a^..)     # from rev 'a' until HEAD
  ${0##*/} \$(git rev-list a^..b)     # from rev 'a' until revision 'b'
  ${0##*/} \$(git rev-list a..)       # from child of rev 'a' until HEAD
  ${0##*/} \$(git rev-list HEAD)      # all revs until HEAD
  KEY_DIR=/path KEY_SUFFIX=.gpg ${0##*/}  # custom key path and suffix"
}

case "${1-}" in
  -h|--?help) usage; exit 1;;
  *) ;;
esac

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
command -v gpg >/dev/null ||
  { printf '%s\n' "Missing program: gpg" >&2; exit 1; }
command -v gpgconf >/dev/null ||
  { printf '%s\n' "Missing program: gpgconf" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel

gpg_homedir="$(mktemp -d)"
trap 'rm -rf -- "${gpg_homedir}"' EXIT INT HUP QUIT ABRT
export GNUPGHOME="${gpg_homedir}"
otrust="${gpg_homedir}/otrust.txt"
gpg_agent="$(gpgconf --list-components | awk -F: '/^gpg-agent:/{print $3}')"
gpg_cmd="gpg --status-fd=2"

${gpg_cmd} --agent-program "${gpg_agent}" \
  --import "${key_dir}"/*"${key_suffix}" >/dev/null 2>&1

${gpg_cmd} --with-colons --list-public-keys | awk -F ':' '{
  if (prev_line ~ /^pub$/ && $1 ~ /^fpr$/) {
      print $10 ":6:"
  }
  prev_line = $1
}' | tee -- "${otrust}" >/dev/null

${gpg_cmd} --import-ownertrust "${otrust}" >/dev/null 2>&1

fail="0"

for rev in "${@:-"HEAD"}"; do
  tag_success="0"
  rev="$(git rev-parse --verify "${rev}")"

  if git verify-commit -- "${rev}" >/dev/null 2>&1; then
    continue
  fi

  tag_list="$(git tag --points-at="${rev}")"
  if test -n "${tag_list}"; then
    for tag in ${tag_list}; do
      if git verify-tag -- "${tag}" >/dev/null 2>&1; then
        tag_success="1"
        continue
      fi
    done
  fi
  if test "${tag_success}" = "1"; then
    continue
  fi

  fail=1
  printf '%s\n' "error: no valid signature associated with rev: ${rev}" >&2
done

if test "${fail}" = "1"; then
  exit 1
fi
