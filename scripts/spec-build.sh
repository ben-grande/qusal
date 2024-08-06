#!/bin/sh

## SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

usage(){
  printf '%s\n' "Usage: ${0##*/} PROJECT [PROJECT ...]" >&2
  exit 1
}

build_rpm(){
  counter=$((counter+1))
  project="${1}"
  group="$(${spec_get} "${project}" group)"
  version="$(${spec_get} "${project}" version)"
  spec="rpm_spec/${group}-${project}.spec"

  "${spec_gen}" "${project}"

  ## All specs have the same format, only lint the first one.
  if test "${counter}" = "1"; then
    rpmlint "${spec}"
  fi

  if grep -q -e "^BuildRequires: " -- "${spec}"; then
    sudo dnf build-dep "${spec}"
  fi

  mkdir -p -- \
    "${build_dir}/BUILD/${group}-${project}/LICENSES/" \
    "${build_dir}/SOURCES/${group}-${project}/LICENSES"

  ## TODO: generate tarball to sources.
  cp -r -- . "${build_dir}/BUILD/${group}-${project}/"
  cp -r -- . "${build_dir}/SOURCES/${group}-${project}/"

  ## TODO: use qubes-builderv2 with mock or qubes executor
  rpmbuild -ba --quiet --clean -- "${spec}"
  if test -n "${key_id}"; then
    rpm_basename="${build_dir}/RPMS/noarch/${group}-${project}-${version}-"
    rpm_suffix=".noarch.rpm"
    ## TODO: target only the latest release
    rpmsign --key-id="${key_id}" --digest-algo=sha512 --addsign \
      -- "${rpm_basename}"*"${rpm_suffix}" </dev/null
    gpg="$(git config --get gpg.program)" || gpg="gpg"
    dbpath="$(mktemp -d)"
    trap 'rm -rf -- "${dbpath}"' EXIT INT HUP QUIT ABRT
    tmp_file="${dbpath}/${key_id}.asc"
    "${gpg}" --export --armor "${key_id}" | tee -- "${tmp_file}" >/dev/null
    rpmkeys --dbpath="${dbpath}" --import "${tmp_file}"
    ## TODO: target only the latest release
    rpmkeys --dbpath="${dbpath}" --checksig --verbose \
      -- "${rpm_basename}"*"${rpm_suffix}"
  fi
}

case "${1-}" in
  -h|--?help) usage;;
  *) ;;
esac

command -v git >/dev/null ||
  { printf '%s\n' "Missing program: git" >&2; exit 1; }
repo_toplevel="$(git rev-parse --show-toplevel)"
test -d "${repo_toplevel}" || exit 1
cd "${repo_toplevel}"
unset repo_toplevel
./scripts/requires-program.sh dnf rpmlint rpmbuild rpmsign
build_dir="${HOME}/rpmbuild"

if command -v rpmdev-setuptree >/dev/null; then
  rpmdev-setuptree
else
  mkdir -p -- \
    "${build_dir}/BUILD" "${build_dir}/BUILDROOT" "${build_dir}/RPMS" \
    "${build_dir}/SOURCES" "${build_dir}/SPECS" "${build_dir}/SRPMS"
fi

key_id="$(git config --get user.signingKey)" || true
spec_gen="./scripts/spec-gen.sh"
spec_get="./scripts/spec-get.sh"

if test -z "${1-}"; then
  # shellcheck disable=SC2046,SC2312
  set -- $(find salt/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
            | sort -d | tr "\n" " ")
fi
counter=0
for p in "${@}"; do
  build_rpm "${p}"
done
