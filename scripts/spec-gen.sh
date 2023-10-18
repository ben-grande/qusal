#!/bin/sh
set -eu

usage(){
  echo "Usage: ${0##*/} PROJECT [PROJECT ...]"
}

gen_spec(){
  project="${1}"
  group="qusal"
  if ! test -d "${group}/${project}"; then
    echo "Project doesn't exist: ${group}/${project}" >&2
    exit 1
  fi
  template="rpm_spec/example.spec.tpl"
  target="rpm_spec/${group}-${project}.spec"

  ## Test if a standard option works without error.
  "${spec_get}" "${project}" name >/dev/null
  version="$("${spec_get}" "${project}" version)"
  changelog="$("${spec_get}" "${project}" changelog)"
  requires="$("${spec_get}" "${project}" requires)"

  sed -e "s/@VERSION@/${version}/" -e "s/@PROJECT@/${project}/" \
    -e "/@CHANGELOG@/d" "${template}" | tee "${target}" >/dev/null
  requires_key=""
  for r in $(printf %s"${requires}" | tr " " "\n"); do
    requires_key="${requires_key}\nRequires: ${r}"
  done
  sed -i "s/@REQUIRES@/${requires_key}/" "${target}" >/dev/null
  echo "${changelog}" | tee -a "${target}" >/dev/null
}

case "${1-}" in
  ""|-h|--?help) usage; exit 1;;
esac

command -v git >/dev/null ||
  { printf "Missing program: git\n" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)"

spec_get="./scripts/spec-get.sh"

for p in "$@"; do
  gen_spec "${p}"
done
