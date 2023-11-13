#!/bin/sh

## SPDX-FileCopyrightText: 2023 Benjamin Grande M. S. <ben.grande.b@gmail.com>
##
## SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

usage(){
  printf '%s\n' "Usage: ${0##*/} PROJECT [release]" >&2
  exit 1
}

case "${1-}" in
  ""|-*) usage;;
esac

release=""
case "${2-}" in
  release) release="1";;
  "") ;;
  *) usage;;
esac

command -v dnf >/dev/null ||
  { printf "Missing program: dnf\n" >&2; exit 1; }
command -v rpmlint >/dev/null ||
  { printf "Missing program: rpmlint\n" >&2; exit 1; }
## command -v rpmdev-setuptree >/dev/null ||
##   { printf "Missing program: rpmdev-setuptree\n" >&2; exit 1; }
command -v rpmbuild >/dev/null ||
  { printf "Missing program: rpmbuild\n" >&2; exit 1; }
command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)" || exit 1

project="${1}"
spec_gen="./scripts/spec-gen.sh"
spec_get="./scripts/spec-get.sh"
group="$(${spec_get} "${project}" group)"
spec="rpm_spec/${group}-${project}.spec"

"${spec_gen}" "${project}"
rpmlint "${spec}"

if grep -q "^BuildRequires: " "${spec}"; then
  sudo dnf build-dep "${spec}"
fi

if command -v rpmdev-setuptree >/dev/null; then
  rpmdev-setuptree
else
  mkdir -p ~/rpmbuild/BUILD ~/rpmbuild/BUILDROOT ~/rpmbuild/RPMS
  mkdir -p ~/rpmbuild/SOURCES ~/rpmbuild/SPECS ~/rpmbuild/SRPMS
fi

mkdir ~/rpmbuild/BUILD/"${group}-${project}"
mkdir ~/rpmbuild/SOURCES/"${group}-${project}"

cp -r "salt/${project}"/* ~/rpmbuild/BUILD/"${group}-${project}"/
cp -r "salt/${project}"/* ~/rpmbuild/SOURCES/"${group}-${project}"/

if test -n "${release}"; then
  rpmbuild -ba --sign "${spec}"
else
  rpmbuild -ba "${spec}"
fi
