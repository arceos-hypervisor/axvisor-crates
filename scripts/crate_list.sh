#!/bin/bash

# The REPOS should be the only entry point to init and generate crate list.
#
# Steps to add a new repo:
# * add the repo name to REPOS
# * `./scripts/submodule.sh init` to add it as a submodule and sort .gitmodules
# * `./scripts/submodule.sh update` to download the submodule
# * `./scripts/crate_list.sh gen` to update the list in README
#
# Steps to remove a repo:
# * remove it from REPOS
# * remove it from .gitmodules (and probably also from your local repo config)
# * `./scripts/crate_list.sh gen` to update the list in README

ORG=arceos-hypervisor
ROOT=https://github.com/arceos-hypervisor
REPOS=(
  "arm_vcpu"
  "arm_vgic"
  "axaddrspace"
  "axcpu"
  "axdevice"
  "axdevice_base"
  "axhvc"
  "axplat-aarch64-dyn"
  "axvcpu"
  "axvirtio-devices"
  "axvisor_api"
  "axvm"
  "axvmconfig"
  "range-alloc"
  "riscv-h"
  "riscv_vcpu"
  "x86_vcpu"
  "x86_vlapic"
)

# Run as `scripts/crate_list.sh gen`
if [[ "$1" == "gen" ]]; then
  SCRIPT_DIR=$(dirname "$(realpath "$0")")
  TARGET_FILE=$(realpath "$SCRIPT_DIR/../README.md")
  SOURCE_FILE="list.txt"

  if [ ! -f "$TARGET_FILE" ]; then
    echo "$TARGET_FILE doesn't exits!"
    exit 1
  fi

  "$SCRIPT_DIR/gen_list.sh" | tee "$SOURCE_FILE"

  awk '
  NR==FNR {
    new_content = (FNR == 1 ? $0 : new_content ORS $0)
    next
  }
  /<!-- crate-list-start -->/ {
    print $0
    print new_content
    skip = 1
    next
  }
  /<!-- crate-list-end -->/ {
    skip = 0
  }
  !skip { print $0 }
' "$SOURCE_FILE" "$TARGET_FILE" >temp.md &&
    mv temp.md "$TARGET_FILE" &&
    rm "$SOURCE_FILE"
fi

is_repo() {
  for repo in "${REPOS[@]}"; do
    if [[ "$1" == "$repo" ]]; then
      return 0
    fi
  done
  return 1
}

# Run as `crate_list.sh is_repo name`
if [[ "$1" == "is_repo" && -n "$2" ]] && ! is_repo $2; then
  # The name is not an expected repo.
  exit 1
fi

# Accept the crate name and return the potential crate url.
get_crate_url() {
  local name=$1
  local len=${#name}

  if [ "$len" -eq 1 ]; then
    echo "https://index.crates.io/1/$name"
  elif [ "$len" -eq 2 ]; then
    echo "https://index.crates.io/2/$name"
  elif [ "$len" -eq 3 ]; then
    echo "https://index.crates.io/3/${name:0:1}/$name"
  else
    echo "https://index.crates.io/${name:0:2}/${name:2:2}/$name"
  fi
}

CRATES_HIDDEN=(
  "axvisor_api_proc"
)

is_hidden_crate() {
  for hidden in "${CRATES_HIDDEN[@]}"; do
    if [[ "$1" == "$hidden" ]]; then
      return 0
    fi
  done
  return 1
}
