#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

usage(){
  echo "Usage: ${0##*/} PROJECT [PROJECT ...]"
}

## Escape multiline strings for sed.
escape_key(){
  key_type="${1}"
  if test "${key_type}" = "scriptlet"; then
    echo "${2}" | sed ':a;N;$!ba;s/\n/\\n  /g' | sed 's/\$/\\$/'
  elif test "${key_type}" = "text"; then
    echo "${2}" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/\$/\\$/'
  else
    return 1
  fi
}

# get_scriptlet scriptlet-action
# [pre|post]-[install|upgrade], [pre|post]un-[uninstall|upgrade]
## Get scriptlet command, else fail safe.
get_scriptlet(){
  scriptlet="$1"
  scriptlet="$(sed -n \
    "/^<\!-- pkg:begin:${scriptlet} -->$/,/^<\!-- pkg:end:${scriptlet} -->$/p" \
    "${readme}" | sed '/^```.*/d;/^\S*$/d;/^<\!-- pkg:/d;s/^sudo //')"
  if test -z "${scriptlet}"; then
    echo true
    return 0
  fi
  escape_key scriptlet "${scriptlet}"
}

get_spec(){
  "${spec_get}" "${project}" "${1}"
}

gen_spec(){
  project="${1}"

  if echo "${unwanted}" | grep -q "^${project}$"; then
    echo "warn: skipping spec generation of untracked formula: ${project}" >&2
    return 0
  fi

  ## Test if a standard option works without error.
  get_spec name >/dev/null

  group="$(get_spec group)"
  template="rpm_spec/template/template.spec"
  target="rpm_spec/${group}-${project}.spec"
  intended_target="${target}"
  if test "${2-}" = "test"; then
    tmpdir="$(mktemp -d)"
    target="${tmpdir}/${group}-${project}.spec"
    trap 'rm -rf -- "${tmpdir}"' EXIT INT HUP QUIT ABRT
  fi

  readme="$(get_spec readme)"

  project_name="$(get_spec project)"
  version="$(get_spec version)"
  license="$(get_spec license)"
  license_csv="$(get_spec license_csv)"
  vendor="$(get_spec vendor)"
  packager="$(get_spec packager)"
  url="$(get_spec url)"
  bug_url="$(get_spec bug_url)"
  requires="$(get_spec requires)"
  summary="$(get_spec summary)"
  description="$(escape_key text "$(get_spec description)")"
  file_roots="$(get_spec file_roots)"
  changelog="$(get_spec changelog)"

  pre_install="$(get_scriptlet pre-install)"
  pre_upgrade="$(get_scriptlet pre-upgrade)"
  post_install="$(get_scriptlet post-install)"
  post_upgrade="$(get_scriptlet post-upgrade)"
  preun_uninstall="$(get_scriptlet preun-uninstall)"
  preun_upgrade="$(get_scriptlet preun-upgrade)"
  postun_uninstall="$(get_scriptlet postun-uninstall)"
  postun_upgrade="$(get_scriptlet postun-upgrade)"

  sed \
    -e "s/@PRE_INSTALL@/${pre_install}/" \
    -e "s/@PRE_UPGRADE@/${pre_upgrade}/" \
    -e "s/@POST_INSTALL@/${post_install}/" \
    -e "s/@POST_UPGRADE@/${post_upgrade}/" \
    -e "s/@PREUN_UNINSTALL@/${preun_uninstall}/" \
    -e "s/@PREUN_UPGRADE@/${preun_upgrade}/" \
    -e "s/@POSTUN_UNINSTALL@/${postun_uninstall}/" \
    -e "s/@POSTUN_UPGRADE@/${postun_upgrade}/" \
    -e "s|@FILE_ROOTS@|${file_roots}|" \
    -e "s/@NAME@/${project}/" \
    -e "s/@PROJECT@/${project_name}/" \
    -e "s/@VERSION@/${version}/" \
    -e "s/@SUMMARY@/${summary}/" \
    -e "s/@GROUP@/${group}/" \
    -e "s/@PACKAGER@/${packager}/" \
    -e "s/@VENDOR@/${vendor}/" \
    -e "s/@LICENSE@/${license}/" \
    -e "s/@LICENSE_CSV@/${license_csv}/" \
    -e "s|@BUG_URL@|${bug_url}|" \
    -e "s|@URL@|${url}|" \
    -e "s|@DESCRIPTION@|${description}|" \
    -e "/@CHANGELOG@/d" \
    "${template}" | tee "${target}" >/dev/null

  requires_key=""
  for r in $(printf %s"${requires}" | tr " " "\n" | sort -u); do
    requires_key="${requires_key:-}Requires:       ${group}-${r}\n"
  done
  sed -i "s/@REQUIRES@/${requires_key}/" "${target}" >/dev/null
  echo "${changelog}" | tee -a "${target}" >/dev/null

  if test "${2-}" = "test"; then
    if ! cmp -s "${target}" "${intended_target}"; then
      echo "${0##*/}: error: File ${intended_target} is not up to date" >&2
      echo "${0##*/}: error: Update the spec with: ${0##/*} ${project}" >&2
      exit 1
    fi
  fi
}

case "${1-}" in
  -h|--?help) usage; exit 1;;
esac

command -v git >/dev/null || { echo "Missing program: git" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)"

spec_get="./scripts/spec-get.sh"

ignored="$(git ls-files --exclude-standard --others --ignored salt/)"
untracked="$(git ls-files --exclude-standard --others salt/)"
unwanted="$(printf %s"${ignored}\n${untracked}\n" \
            | grep "^salt/\S\+/README.md" | cut -d "/" -f2 | sort -u)"

if test "${2-}" = "test"; then
  gen_spec "${1}" test
  exit
fi

if test -z "${1-}"; then
  # shellcheck disable=SC2046
  set -- $(find salt/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
           | sort -d | tr "\n" " ")
fi
for p in "$@"; do
  gen_spec "${p}"
done
