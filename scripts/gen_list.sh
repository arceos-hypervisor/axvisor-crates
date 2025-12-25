#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
# Import variables.
source "$SCRIPT_DIR/crate_list.sh"

# Make the second column larger via &nbsp;
echo '| Crate | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;crates.io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Documentation | Description |'
echo '|----|---|:--:|----|'

for repo in ${REPOS[@]}; do
  pushd crates/$repo >/dev/null
  branch=""

  cargo metadata --no-deps --format-version 1 |
    jq -cr '.packages | .[] | "\(.name) \(.manifest_path) \(.description)"' |
    while read -r crate manifest_path description; do

      if is_hidden_crate $crate; then
        continue
      fi

      folder=${manifest_path#$PWD/}
      folder=${folder%Cargo.toml}
      # folder is empty if the toml is right under the project root
      if [[ -z $folder ]]; then
        url="$ROOT/$repo"
      else
        : ${branch:=$(curl -s https://api.github.com/repos/$ORG/$repo | jq -r .default_branch)}
        url="$ROOT/$repo/tree/$branch/$folder"
      fi

      if curl --output /dev/null --silent --head --fail $(get_crate_url $crate); then
        # In crates.io
        crates_io="[![Crates.io](https://img.shields.io/crates/v/$crate)](https://crates.io/crates/$crate)"
        doc="[![Docs.rs](https://docs.rs/$crate/badge.svg)](https://docs.rs/$crate)"
      else
        # Not in crates.io
        crates_io="N/A"
        doc_url="https://arceos-hypervisor.github.io/$repo"
        doc="[![Docs.rs](https://img.shields.io/badge/docs-pages-green)]($doc_url)"
      fi

      description="$description."
      echo "| [$crate]($url) | $crates_io | $doc | $description |"

    done

  popd >/dev/null
done
