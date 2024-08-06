#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

usage(){
  printf '%s\n' "Usage: ${0##*/} PROJECT [PROJECT ...]"
}

## Escape multiline strings for sed.
escape_key(){
  key_type="${1}"
  if test "${key_type}" = "scriptlet"; then
    printf '%s\n' "${2}" | sed -e ':a;N;$!ba;s/\n/\\n  /g' | \
      sed -e 's/\$/\\$/'
  elif test "${key_type}" = "text"; then
    printf '%s\n' "${2}" | sed -e ':a;N;$!ba;s/\n/\\n/g' | sed -e 's/\$/\\$/'
  else
    return 1
  fi
}

# get_scriptlet scriptlet-action
# [pre|post]-[install|upgrade], [pre|post]un-[uninstall|upgrade]
## Get scriptlet command, else fail safe.
get_scriptlet(){
  scriptlet="$1"
  scriptlet_begin="-- pkg:begin:${scriptlet} --"
  scriptlet_end="-- pkg:end:${scriptlet} --"
  scriptlet="$(sed -n -e \
    "/^<\!${scriptlet_begin}>$/,/^<\!${scriptlet_end}>$/p" \
    -- "${readme}" | sed -e '/^```.*/d;/^\S*$/d;/^<\!-- pkg:/d;s/^sudo //')"
  if test -z "${scriptlet}"; then
    printf '%s\n' "true"
    return 0
  fi
  escape_key scriptlet "${scriptlet}"
}

get_spec(){
  "${spec_get}" "${project}" "${1}"
}

gen_spec(){
  project="$(printf '%s\n' "${1}" | sed -e "s|salt/||;s|/.*||")"
  if printf '%s\n' "${projects_seen}" | grep -qF -e " ${project} "; then
    return
  fi
  projects_seen="${projects_seen} ${project} "

  if printf '%s\n' "${unwanted}" | grep -q -e "^${project}$"; then
    printf '%s\n' "warn: skipping spec of untracked formula: ${project}" >&2
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
  license_csv="$(get_spec license_csv)"
  ## Ideally we would query the license, but it is a heavy call.
  license="$(printf '%s\n' "${license_csv}" | sed -e "s/\,/ AND /g")"
  vendor="$(get_spec vendor)"
  packager="$(get_spec packager)"
  url="$(get_spec url)"
  bug_url="$(get_spec bug_url)"
  requires="$(get_spec requires)"
  summary="$(get_spec summary)"
  description="$(get_spec description)"
  description="$(escape_key text "${description}")"
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
    -- "${template}" | tee -- "${target}" >/dev/null

  requires_key=""
  for r in $(printf '%s' "${requires}" | tr " " "\n" | sort -u); do
    requires_key="${requires_key:-}Requires:       ${group}-${r}\n"
  done
  sed -i -e "s/@REQUIRES@/${requires_key}/" -- "${target}" >/dev/null
  printf '%s\n' "${changelog}" | tee -a -- "${target}" >/dev/null

  if test "${2-}" = "test"; then
    if ! cmp -s -- "${target}" "${intended_target}"; then
      printf '%s\n' "error: ${intended_target} is not up to date" >&2
      diff --color=auto -- "${intended_target}" "${target}" || true
      fail=1
    else
      unstaged_target="$(git diff --name-only -- "${intended_target}")" ||
        true
      if test -n "${unstaged_target}"; then
        err_msg="warn: ${intended_target} is up to date but it is not staged"
        printf '%s\n' "${err_msg}" >&2
      fi
    fi
  fi
}

case "${1-}" in
  -h|--?help) usage; exit 1;;
  *) ;;
esac

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel

spec_get="./scripts/spec-get.sh"
ignored="$(git ls-files --exclude-standard --others --ignored salt/)"
untracked="$(git ls-files --exclude-standard --others salt/)"
unwanted="$(printf '%s\n%s\n' "${ignored}" "${untracked}" \
            | grep -e "^salt/\S\+/README.md" | cut -d "/" -f2 | sort -u)"

fail=""
gen_mode=""

if test "${1-}" = "test"; then
  gen_mode="test"
  shift
fi

if printf '%s\n' "${@}" | \
  grep -qE -e "(^scripts/| scripts/|/template.spec)" ||
  test -z "${1-}"
then
  # shellcheck disable=SC2046,SC2312
  set -- $(find salt/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
            | sort -d | tr "\n" " ")
fi

projects_seen=""
for p in "${@}"; do
  gen_spec "${p}" "${gen_mode}"
done

if test "${fail}" = "1" && test "${gen_mode}" = "test"; then
  exit 1
fi
