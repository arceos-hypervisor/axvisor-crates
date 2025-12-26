#!/bin/bash

ORG=arceos-hypervisor
ROOT=https://github.com/arceos-hypervisor
# The REPOS should be the only entry point to init and generate crate list.
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

# Run as `scripts/crate_list.sh gen` to update README crate list.
if [[ "$1" == "gen" ]]; then
  SCRIPT_DIR=$(dirname "$(realpath "$0")")
  TARGET_FILE=$(realpath "$SCRIPT_DIR/../README.md")
  SOURCE_FILE="list.txt"

  if [ ! -f "$TARGET_FILE" ]; then
    echo "$TARGET_FILE doesn't exits!"
    exit 1
  fi

  # Generate new crate list and write it to a txt.
  "$SCRIPT_DIR/gen_list.sh" | tee "$SOURCE_FILE"

  # Update crate list in README.
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

# Run as `crate_list.sh is_repo name`. Only used in `gen_list.sh`.
if [[ "$1" == "is_repo" && -n "$2" ]] && ! is_repo $2; then
  # The name is not an expected repo.
  exit 1
fi

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
