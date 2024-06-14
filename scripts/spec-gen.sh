#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

usage(){
  echo "Usage: ${0##*/} PROJECT [PROJECT ...]"
}

## Escape multiline strings for sed.
escaped_key(){
  echo "${1}" | sed ':a;N;$!ba;s/\n/\\n  /g' | sed 's/\$/\\$/'
}


# get_scriptlet scriptlet-action
# [pre|post]-[install|upgrade], [pre|post]un-[uninstall|upgrade]
## Get scriptlet command, else fail safe.
get_scriptlet(){
  scriptlet="$1"
  scriptlet="$(sed -n \
    "/^<\!-- pkg:begin:${scriptlet} -->$/,/^<\!-- pkg:end:${scriptlet} -->$/p" \
    "${readme}" | sed '/^```.*/d;/^<\!-- pkg:/d;s/^sudo //')"
  if test -z "${scriptlet}"; then
    echo true
    return 0
  fi
  escaped_key "${scriptlet}"
}

get_spec(){
  "${spec_get}" "${project}" "${1}"
}

gen_spec(){
  project="${1}"

  ## Test if a standard option works without error.
  get_spec name >/dev/null

  group="$(get_spec group)"
  template="rpm_spec/template/template.spec"
  target="rpm_spec/${group}-${project}.spec"

  readme="$(get_spec readme)"

  pre_install="$(get_scriptlet pre-install)"
  pre_upgrade="$(get_scriptlet pre-upgrade)"
  post_install="$(get_scriptlet post-install)"
  post_upgrade="$(get_scriptlet post-upgrade)"
  preun_uninstall="$(get_scriptlet preun-uninstall)"
  preun_upgrade="$(get_scriptlet preun-upgrade)"
  postun_uninstall="$(get_scriptlet postun-uninstall)"
  postun_upgrade="$(get_scriptlet postun-upgrade)"

  version="$(get_spec version)"
  changelog="$(get_spec changelog)"
  requires="$(get_spec requires)"

  sed \
    -e "s/@PRE_INSTALL@/${pre_install}/" \
    -e "s/@PRE_UPGRADE@/${pre_upgrade}/" \
    -e "s/@POST_INSTALL@/${post_install}/" \
    -e "s/@POST_UPGRADE@/${post_upgrade}/" \
    -e "s/@PREUN_UNINSTALL@/${preun_uninstall}/" \
    -e "s/@PREUN_UPGRADE@/${preun_upgrade}/" \
    -e "s/@POSTUN_UNINSTALL@/${postun_uninstall}/" \
    -e "s/@POSTUN_UPGRADE@/${postun_upgrade}/" \
    -e "s/@VERSION@/${version}/" \
    -e "s/@PROJECT@/${project}/" \
    -e "/@CHANGELOG@/d" \
    "${template}" | tee "${target}" >/dev/null

  requires_key=""
  for r in $(printf %s"${requires}" | tr " " "\n" | sort -u); do
    requires_key="${requires_key}\nRequires:       ${group}-${r}"
  done
  sed -i "s/@REQUIRES@/${requires_key}/" "${target}" >/dev/null
  echo "${changelog}" | tee -a "${target}" >/dev/null
}

case "${1-}" in
  -h|--?help) usage; exit 1;;
esac

command -v git >/dev/null || { echo "Missing program: git" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)"

spec_get="./scripts/spec-get.sh"

if test -z "${1-}"; then
  # shellcheck disable=SC2046
  set -- $(find salt/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
           | sort -d | tr "\n" " ")
fi
for p in "$@"; do
  gen_spec "${p}"
done
