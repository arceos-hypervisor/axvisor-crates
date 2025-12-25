#!/bin/bash

# The REPOS should be the only entry point to init and generate crate list.
#
# The steps to add a new repo:
# * add the repo name to REPOS
# * `./scripts/submodule.sh init` to add it as a submodule and sort .gitmodules
# * `./scripts/submodule.sh update` to download the submodule
# * `./scripts/gen_list.sh > tmp.txt` and replace the list in README by tmp.txt
#
# The steps to remove a repo:
# * remove it from REPOS
# * remove it from .gitmodules (and probably also from your local repo config)
# * follow the same steps in adding a repo as above

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

is_repo() {
  for repo in "${REPOS[@]}"; do
    if [[ "$1" == "$repo" ]]; then
      return 0
    fi
  done
  return 1
}

# Run as `./crate_list.sh is_repo name`
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
